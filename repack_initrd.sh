#!/bin/bash

PREBUILT_UINITRD=`pwd`/prebuilt/uInitrd
OUTPUT_DIR=`pwd`/output
SCRIPT_DIR=`pwd`/scripts

[ -d $OUTPUT_DIR/sys_root ] || mkdir $OUTPUT_DIR/sys_root

pushd $OUTPUT_DIR
dd if=$PREBUILT_UINITRD of=initrd.gz bs=64 skip=1

pushd $OUTPUT_DIR/sys_root
gunzip -c $OUTPUT_DIR/initrd.gz | cpio -ivd

cp -rf $SCRIPT_DIR/* .

find . | cpio -o -H newc | gzip > $OUTPUT_DIR/initrd.gz

popd
mkimage -A arm -O linux -T ramdisk -C none -a 0 -e 0 -n uInitrd -d initrd.gz uInitrd

rm -rf $OUTPUT_DIR/sys_root

ls -al $OUTPUT_DIR/uInitrd
