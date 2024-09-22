## Armbian for Onn 4K TV-Box (Dopinder)

### Needed

* OTG Cable (required)
* USB Hub (recommended)
* USB to Ethernet adapter (recommended)

### Working

- HDMI
- Audio
- Bluetooth
- Wi-Fi

### Images 

[Prebuilt Images](https://github.com/sicXnull/Onn4K-TV-Box-Armbian/releases)


### Building Armbian for Onn 4K TV-Box

Download `armbian-build` and apply the patch:

```
$ git clone --depth=1 https://github.com/armbian/build armbian-build
$ cp -R armbian-patch/* armbian-build/
```

Build:

```
$ cd armbian-build
$ ./compile.sh build BOARD=onn4k BRANCH=current BUILD_DESKTOP=yes BUILD_MINIMAL=no DESKTOP_APPGROUPS_SELECTED= DESKTOP_ENVIRONMENT=mate DESKTOP_ENVIRONMENT_CONFIG_NAME=config_base EXPERT=yes KERNEL_CONFIGURE=no KERNEL_GIT=shallow RELEASE=bookworm
```

* Change as desired (jammy/noble/etc)

### Post script

```
$ cd ..
$ sudo ./postscript.sh
```

This will copy the files needed to the boot partition of the Armbian Image.

### Writing to USB

Prepare to write the image to USB.

``` 
cd armbian-build/output/images
sudo dd if=Armbian-unofficial_24.11.0-trunk_Onn4k_bookworm_current_6.6.48_mate_desktop.img of=/dev/sdb bs=4M status=progress
```
* Adjust `Armbian-unofficial_24.11.0-trunk_Onn4k_bookworm_current_6.6.48_mate_desktop.img`" to current filename.
* Adjust `/dev/sdb` to the correct device for your USB drive.

### Booting from USB


* Plug it into your onn 4K UHD using an OTG cable, and hold the reset button while plugging in power.
* For future boots, you just need the USB drive plugged in during poweron. There is no more need to hold the reset button.

### Credits
* https://github.com/riptidewave93/dopinder-debian for the configs.
* https://github.com/ilyakurdyukov/rk3528-tvbox for the format I used for the build process.
