ui_print "酷安AMXlil"
ui_print "问题交流群983769627"
ui_print "- 安装须知（必读）"
ui_print "此ak3仅支持欧真加机型刷入请核对好机型"
ui_print "请核对好内核版本号再刷入"
ui_print "  [音量上] : 加入QQ群并安装 "
ui_print "  [音量下] : 直接安装 "
ui_print "============================================="

jump="false"
key=$(waitkey)

if [ "$key" = "up" ]; then
    jump="true"
    ui_print "- "
else
    ui_print "- "
fi

if [ "$jump" = "true" ]; then
    boot=$("$GP" sys.boot_completed)
    if [ "$boot" = "1" ]; then
        ui_print "- 正在打开酷安..."
        am start -a android.intent.action.VIEW -d "https://qun.qq.com/universal-share/share?ac=1&authKey=hgLgcwLRqmp8srmgb9TJliL0AFuEOg8mAhmyAdHcbfGS%2B9LUFbef05IYdsQfQymH&busi_data=eyJncm91cENvZGUiOiI5ODM3Njk2MjciLCJ0b2tlbiI6ImZId3A2NkxLb0NSQzhkVzdoelFUc2ZlZnVFdCtoVHVXcDViV1laeUtBeUZIRkZtNFJFODJNM05aYjdkZmVOalciLCJ1aW4iOiIyNzIyMDQ4OTk3In0%3D&data=w6zieS1V9B-Nb8Ni2JKBUnoeDLxXRu_06J0RI42pw8R0qjRYURrxdn_yZ1yAO8Rr9r-VZZyd0I-Kh8T21lxWyw&svctype=4&tempid=h5_group_info" >/dev/null 2>&1
    fi
fi
properties() { '
kernel.string=Build by AMXlil
do.devicecheck=0
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=1
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot shell variables
block=boot
is_slot_device=auto
ramdisk_compression=auto
patch_vbmeta_flag=auto
no_magisk_check=1

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh

kernel_version=$(cat /proc/version | awk -F '-' '{print $1}' | awk '{print $3}')
case $kernel_version in
    4.1*) ksu_supported=true ;;
    5.1*) ksu_supported=true ;;
    6.1*) ksu_supported=true ;;
    6.6*) ksu_supported=true ;;
    *) ksu_supported=false ;;
esac

ui_print "  -> ksu_supported: $ksu_supported"
$ksu_supported || abort "  -> Non-GKI device, abort."

split_boot
if [ -f "split_img/ramdisk.cpio" ]; then
    unpack_ramdisk
    write_boot
else
    flash_boot
fi
