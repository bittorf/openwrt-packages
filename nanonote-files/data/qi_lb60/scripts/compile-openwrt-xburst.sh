#!/bin/bash
DATE=$(date "+%Y-%m-%d")
TIME=$(date "+%H-%M-%S")
DATE_TIME=`date +"%m%d%Y-%H%M"`

# this script file is using in build host

# $1: full_system  minimal  xbboot
OPENWRT_DIR_NAME="openwrt-xburst."$1
CONFIG_FILE_TYPE="config."$1

# you may need change those Variables
BASE_DIR="/home/xiangfu/compile-log/"
OPENWRT_DIR="/home/xiangfu/${OPENWRT_DIR_NAME}/"
GET_FEEDS_VERSION_SH="/home/xiangfu/bin/get-feeds-revision.sh"

IMAGE_DIR="${BASE_DIR}/${OPENWRT_DIR_NAME}-${DATE_TIME}/"
BUILD_LOG="${IMAGE_DIR}/BUILD_LOG"
VERSIONS_FILE="${IMAGE_DIR}/VERSIONS"

MAKE_VARS=" V=99 IGNORE_ERRORS=m "

########################################################################
cd ${OPENWRT_DIR}

echo "make distclean ..."
make distclean 


echo "updating git repo..."
git fetch -a
git reset --hard origin/master
if [ "$?" != "0" ]; then
	echo "ERROR: updating openwrt-xburst failed"
	exit 1
fi


echo "update and install feeds..."
./scripts/feeds update -a && ./scripts/feeds install -a
if [ "$?" != "0" ]; then
	echo "ERROR: update and install feeds failed"
	exit 1
fi
cp feeds/qipackages/nanonote-files/data/qi_lb60/conf/${CONFIG_FILE_TYPE} .config
sed -i '/CONFIG_ALL/s/.*/CONFIG_ALL=y/' .config 
yes "" | make oldconfig > /dev/null


echo "copy files, create VERSION, copy dl folder, last prepare..."
rm -f files && ln -s feeds/qipackages/nanonote-files/data/qi_lb60/files/
rm -f dl    && ln -s ~/dl
mkdir -p files/etc && echo ${DATE} > files/etc/VERSION


echo "starting compiling - this may take several hours..."
mkdir -p ${IMAGE_DIR}
time make ${MAKE_VARS} > ${IMAGE_DIR}/BUILD_LOG 2>&1
if [ "$?" != "0" ]; then
	echo "ERROR: Build failed! Please refer to the log file"
	tail -n 100 ${IMAGE_DIR}/BUILD_LOG > ${IMAGE_DIR}/BUILD_LOG.`date +"%m%d%Y-%H%M"`.last100
fi


echo "getting version numbers of used repositories..."
${GET_FEEDS_VERSION_SH} ${OPENWRT_DIR} > ${VERSIONS_FILE}


echo "copy all files to IMAGE_DIR..."
cp .config ${IMAGE_DIR}/config
cp feeds.conf ${IMAGE_DIR}/
cp -a bin/xburst/* ${IMAGE_DIR} 2>/dev/null
mkdir -p ${IMAGE_DIR}/files
cp -a files/* ${IMAGE_DIR}/files/

(cd ${IMAGE_DIR}; \
 bzip2 -z BUILD_LOG; \
 bzip2 -z openwrt-xburst-qi_lb60-root.ubi; \
)

echo "DONE :)"