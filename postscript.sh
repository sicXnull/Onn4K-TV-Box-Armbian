#!/bin/bash

# Define the directory to search for the image
IMAGE_DIR="armbian-build/output/images"

# Define the mount directory
MOUNT_DIR="/mnt/armbian_boot"

# Get the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Define the source directory for boot files
BOOT_SOURCE_DIR="$SCRIPT_DIR/boot"

# Find the image file in the specified directory
IMAGE_FILE=$(find "$IMAGE_DIR" -name "Armbian-unofficial_*.img" | head -n 1)

# Check if the image file is found
if [[ -z "$IMAGE_FILE" ]]; then
    echo "No Armbian image file found in $IMAGE_DIR."
    exit 1
else
    echo "Found image file: $IMAGE_FILE"
fi

# Create mount directory if it doesn't exist
mkdir -p "$MOUNT_DIR"

# Use losetup to find the next available loop device
LOOP_DEVICE=$(losetup --find --show "$IMAGE_FILE")

# Use partprobe to inform the OS of partition changes
partprobe "$LOOP_DEVICE"

# Get the boot partition (assuming it has 'boot' in its name)
BOOT_PART=$(lsblk -lnp -o NAME,LABEL "$LOOP_DEVICE" | grep -i "boot" | awk '{print $1}')

# Check if the boot partition is found
if [[ -z "$BOOT_PART" ]]; then
    echo "No boot partition found in $IMAGE_FILE."
    losetup -d "$LOOP_DEVICE"
    exit 1
else
    echo "Found boot partition: $BOOT_PART"
fi

# Mount the boot partition
mount "$BOOT_PART" "$MOUNT_DIR"
if [[ $? -eq 0 ]]; then
    echo "Mounted $BOOT_PART to $MOUNT_DIR."
else
    echo "Failed to mount $BOOT_PART."
    losetup -d "$LOOP_DEVICE"
    exit 1
fi

# Copy files from the boot folder to the mount directory
if [[ -d "$BOOT_SOURCE_DIR" ]]; then
    echo "Copying files from $BOOT_SOURCE_DIR to $MOUNT_DIR..."
    cp -r "$BOOT_SOURCE_DIR"/* "$MOUNT_DIR/"
    if [[ $? -eq 0 ]]; then
        echo "Files copied successfully."
    else
        echo "Failed to copy files."
        umount "$MOUNT_DIR"
        losetup -d "$LOOP_DEVICE"
        exit 1
    fi
else
    echo "Boot source directory $BOOT_SOURCE_DIR does not exist."
    umount "$MOUNT_DIR"
    losetup -d "$LOOP_DEVICE"
    exit 1
fi

# Unmount the boot partition and release loop device
echo "Unmounting boot partition..."
umount "$MOUNT_DIR"
if [[ $? -eq 0 ]]; then
    echo "Unmounted $MOUNT_DIR successfully."
else
    echo "Failed to unmount $MOUNT_DIR."
fi

losetup -d "$LOOP_DEVICE"
if [[ $? -eq 0 ]]; then
    echo "Loop device $LOOP_DEVICE released."
else
    echo "Failed to release loop device $LOOP_DEVICE."
fi

echo "Script completed."
