# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus3T
device.name2=oneplus3t
device.name3=OnePlus3
device.name4=oneplus3
device.name5=
supported.versions=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;

## Alert of unsupported Android version and OOS plebs
oos_ver=$(file_getprop /system/build.prop ro.build.ota.versionname)
if [ $oos_ver != "" ]; then
    ui_print "OxygenOS is NOT supported by Caesium"
    exit 9
fi
android_ver=$(file_getprop /system/build.prop ro.build.version.release)
case "$android_ver" in
  "6.0"|"6.0.1"|"7.0"|"7.1"|"7.1.1"|"7.1.2") compatibility_string="your version is unsupported, expect no support from the kernel developer!";;
  "8.0.0"|"8.1.0"|"9") compatibility_string="your version is supported!";;
esac;

ui_print "Android $android_ver detected, $compatibility_string";

## AnyKernel install
dump_boot;

# begin ramdisk changes
insert_line init.qcom.rc "init.caesium.rc" after "import init.target.rc" "import /init.caesium.rc"

# Delete /system fstab mount (it's mounted in the kernel now)
remove_line fstab.qcom "/dev/block/bootdevice/by-name/system"

# end ramdisk changes

write_boot;

## end install

