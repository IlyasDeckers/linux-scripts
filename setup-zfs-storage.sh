#!/usr/bin/env bash
set -euo pipefail

DISKS=(
  /dev/disk/by-id/wwn-0x55cd2e404c131c5a
  /dev/disk/by-id/wwn-0x55cd2e404c21f4bb 
)
POOL=ssd
MOUNTPOINT=/mnt/ssd

if zpool list -H -o name "${POOL}" &>/dev/null && zpool status "${POOL}" | grep -q raidz2; then
  echo "Pool '${POOL}' already exists as raidz2." >&2
  exit 1
fi

echo "==> Installing ZFS (kernel module matched to $(uname -r))"
pacman -S --needed --noconfirm linux-cachyos-zfs zfs-utils

echo "==> Loading zfs module"
modprobe zfs

if [ ! -f /etc/hostid ]; then
  echo "==> Generating /etc/hostid"
  zgenhostid
fi

echo "==> Loading zfs module at boot via modules-load.d"
mkdir -p /etc/modules-load.d
echo zfs > /etc/modules-load.d/zfs.conf

if zpool list -H -o name "${POOL}" &>/dev/null; then
  echo "==> Destroying existing '${POOL}' pool (rebuilding as raidz2)"
  zpool destroy "${POOL}"
fi

echo "==> Wiping existing filesystem/pool signatures on: ${DISKS[*]}"
for d in "${DISKS[@]}"; do
  zpool labelclear -f "$d" 2>/dev/null || true
  wipefs -a "$d"
done

echo "==> Creating raidz2 pool '${POOL}' mounted at ${MOUNTPOINT}"
zpool create -f \
  -o ashift=12 \
  -O compression=lz4 \
  -O atime=off \
  -O xattr=sa \
  -O mountpoint="${MOUNTPOINT}" \
  "${POOL}" raidz2 "${DISKS[@]}"

echo "==> Enabling ZFS services for boot-time import/mount"
systemctl enable --now zfs.target zfs-import-cache zfs-mount zfs-zed
zpool set cachefile=/etc/zfs/zpool.cache "${POOL}"

echo "==> Done."
zpool status "${POOL}"
zfs list -r "${POOL}"
