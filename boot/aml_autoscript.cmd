# Recompile with...
# mkimage -C none -A arm -T script -d /boot/aml_autoscript.cmd /boot/aml_autoscript

# Update our boot cmd
defenv
setenv bootcmd "usb start && if fatload usb 0:1 0x1000000 u-boot/onn-uhd.uboot; then go 0x1000000; else run storeboot; fi"
saveenv

# Boot our changes
run bootcmd