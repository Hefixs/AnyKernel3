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

. tools/ak3-core.sh
waitkey() {
    command -v getevent >/dev/null 2>&1 || { echo none; return; }
    end=$(($(date +%s) + 60))
    while [ "$(date +%s)" -lt "$end" ]; do
        ev=$(timeout 1 getevent -lqc 1 2>/dev/null | {
            while read -r line; do
                case "$line" in
                    *KEY_VOLUMEDOWN*DOWN*) echo "down"; break ;;
                    *KEY_VOLUMEUP*DOWN*) echo "up"; break ;;
                    *KEY_POWER*DOWN*) input keyevent KEY_POWER; echo "power"; break ;;
                esac
            done
        })
        [ -n "$ev" ] && echo "$ev" && return
    done
    echo timeout
}

ui_print "酷安AMXlil"
ui_print "问题交流群983769627"
ui_print " 安装须知（必读）"
ui_print "此ak3仅支持欧真加机型刷入请核对好机型"
ui_print "请核对好内核版本号再刷入"
ui_print " "
ui_print " "
ui_print "  [音量上] : 已阅读，继续安装"
ui_print "  [音量下] : 退出安装"


key=$(waitkey)
case "$key" in
    up) ;;
    none) ui_print "- 当前环境无法读取按键，以下选项均使用默认值" ;;
    timeout) abort "等待按键超时，请重新刷入" ;;
    *) abort "未阅读须知" ;;
esac
# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
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
