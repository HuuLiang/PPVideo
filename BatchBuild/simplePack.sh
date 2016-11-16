#!/bin/sh


SIGH_EXEC="/usr/local/bin/sigh"
PLIST_BUDDY_EXEC="/usr/libexec/PlistBuddy"
SIGNING_IDENTITY="iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."
PROVISIONING_PROFILE="/Users/liang/Library/MobileDevice/Provisioning Profiles/4dbc4db4-acaa-4179-a060-28ed0a0113f8.mobileprovision"

PROJECT_NAME=$1
MIN_PKG_NO=$2
MAX_PKG_NO=$3

PRG=$0

CURRENT_DIR="`dirname $PRG`"
ABS_DIR="`cd $CURRENT_DIR;pwd`"

PARENT_PACKAGE="${ABS_DIR}/${PROJECT_NAME}.ipa"
PROJECT_APP_NAME="${PROJECT_NAME}.app"
CHANNEL_PREFIX="IOS_A_I" #iOS主包
#CHANNEL_PREFIX="H5-0000" #H5

IPA_STORAGE_DIR="$ABS_DIR/ipas"

[ -d "$IPA_STORAGE_DIR" ] && rm -rf $IPA_STORAGE_DIR

mkdir -p $IPA_STORAGE_DIR

PAYLOAD="$ABS_DIR/Payload"

[ -d "$PAYLOAD" ] && rm -rf $PAYLOAD

unzip $PARENT_PACKAGE -d $ABS_DIR/ > /dev/null

WORKSPACE="$ABS_DIR/workspace"

[ -d "$WORKSPACE" ] && rm -rf $WORKSPACE

mkdir -p $WORKSPACE

THREAD_NUM=6

mkfifo packpipe
exec 9<>packpipe

rm packpipe

for i in `eval echo {1..$THREAD_NUM}`; do
	unzip $PARENT_PACKAGE -d "$WORKSPACE/Payload_`printf "%2d" $i | tr " " 0`/" > /dev/null
	#cp -rfp $PAYLOAD "$WORKSPACE/Payload_`printf "%2d" $i | tr " " 0`/"
	echo "$i" 1>&9
done

while [ $MIN_PKG_NO -le $MAX_PKG_NO ]; do
	read -u 9 seq
	{
		MIN_PKG_NO_PADDING="`printf "%3d" $MIN_PKG_NO | tr " " 0`"
		CURRENT_PKG_STORAGE_DIR="$IPA_STORAGE_DIR/$MIN_PKG_NO_PADDING"
		[ -d "$CURRENT_PKG_STORAGE_DIR" ] && rm -rf $CURRENT_PKG_STORAGE_DIR
		mkdir -p $CURRENT_PKG_STORAGE_DIR

		IPA_FILE="$CURRENT_PKG_STORAGE_DIR/${PROJECT_NAME}.ipa"
		CHANNELNO="$CHANNEL_PREFIX`printf "%8d" $MIN_PKG_NO | tr " " 0`" #iOS主包
#        CHANNELNO="$CHANNEL_PREFIX`printf $MIN_PKG_NO | tr " " 0`" #H5
		CONFIG_PLIST_FILE="$WORKSPACE/Payload_`printf "%2d" $seq | tr " " 0`/Payload/${PROJECT_APP_NAME}/config.plist"
		$PLIST_BUDDY_EXEC -c "set :ChannelNo ${CHANNELNO}" $CONFIG_PLIST_FILE	
		ZIP_DIR="$WORKSPACE/Payload_`printf "%2d" $seq | tr " " 0`/Payload"
		cd $ZIP_DIR
		cd ..
		/usr/bin/zip -qr $IPA_FILE Payload
		$SIGH_EXEC resign $IPA_FILE --signing_identity "${SIGNING_IDENTITY}" --provisioning_profile "${PROVISIONING_PROFILE}"
		echo "$seq" 1>&9
	}&
	let MIN_PKG_NO=MIN_PKG_NO+1
done

wait

echo "successfully package"

exec 9>&-


