### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=sweet
device.name2=sweetin
supported.versions=11 - 17
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
dump_boot;

ui_print " ";
ui_print "======================================================";
ui_print "               SELECT COMPATIBILITY MODE               ";
ui_print "======================================================";
ui_print "    [Vol UP]   : Latest eBPF (HyperOS & Port ROMs)";
ui_print "    [Vol DOWN] : Legacy eBPF (MIUI14 / Older ROMs)";
ui_print "======================================================";

choose_ebpf() {
    ui_print "-> Waiting 15s for volume key input...";
    ui_print "-> Default choice in 15s: Latest eBPF";
    
    local key=$(timeout 15 getevent -l | grep -m1 -E 'KEY_VOLUMEUP|KEY_VOLUMEDOWN')

    case "$key" in
        *KEY_VOLUMEDOWN*)
            ui_print "-> Selected: Legacy eBPF"
            patch_cmdline "init.is_legacy_ebpf" "init.is_legacy_ebpf=true"
            patch_cmdline "init.is_legacy_timestamp" "init.is_legacy_timestamp=true"
            ;;
        *KEY_VOLUMEUP*|*)
            ui_print "-> Selected Latest eBPF"
            patch_cmdline "init.is_legacy_ebpf" "init.is_legacy_ebpf=false"
            patch_cmdline "init.is_legacy_timestamp" "init.is_legacy_timestamp=false"
            ;;
    esac
}

choose_ebpf;
# ==========================================

write_boot;
## end boot install