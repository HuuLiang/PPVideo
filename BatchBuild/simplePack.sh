#!/bin/sh


SIGH_EXEC="/usr/local/bin/sigh"
SIGH_DIS="iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., Ltd."
PROVISION="/Users/liang/Library/MobileDevice/Provisioning Profiles/4dbc4db4-acaa-4179-a060-28ed0a0113f8.mobileprovision"

CONFIG_ROOT_PATH="/Users/liang/Desktop"
cd $CONFIG_ROOT_PATH


sourceIpaName="PPVideo.ipa"
appName="PPVideo.app"
channelHeader="IOS_A_I"

distDir="/Users/liang/Desktop/IOS_A"
rm -rdf "$distDir"
mkdir "$distDir"
unzip $sourceIpaName

for ((i=1;i<100;i++))
do
    cd Payload
    cd $appName
        targetName="PPVideo"
        CHANNELNO="$channelHeader`printf "%8d" $i | tr " " 0`"
        newIpaName="${targetName}_${CHANNELNO}"
        /usr/libexec/PlistBuddy -c "set :ChannelNo ${CHANNELNO}" config.plist
        cd ../..
        zip -r "${newIpaName}.ipa" Payload
        $SIGH_EXEC resign ${newIpaName}.ipa --signing_identity "${SIGH_DIS}" --provisioning_profile "${PROVISION}"
        mv "${newIpaName}.ipa" $distDir
done
rm -rdf Payload

