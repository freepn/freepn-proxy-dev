#! /usr/bin/env bash
# proxy-runner.sh
#

#set -x

PATH=/usr/bin:/bin:/usr/sbin:/sbin
export LC_ALL=C

export http_proxy="127.0.0.1:8080"
export https_proxy="127.0.0.1:8080"

# environemt vars
#VERBOSE="anything"
# used to set download/log path relative to $HOME
CACHEPATH=${1:-.cache/freepn-proxy}
FLOWDIR="${HOME}/${CACHEPATH}/flows"
LOGDIR="${HOME}/${CACHEPATH}"

PORT=8080

if [ "$1" == "-c" ]; then
	CMD="mitmproxy"
else
	echo "Starting proxy server on port $PORT..."
	CMD="mitmdump"
fi

exec &>> "${LOGDIR}/proxy.log"

# TODO: parse args properly (position-independant)
if [ "$1" == "-d" ]; then

	[[ -d "${FLOWDIR}" ]] || mkdir -p "${FLOWDIR}"

	DATE=$(date +%s)
	DUMPFILE="$FLOWDIR/log-${DATE}.flows"
	echo "Dumping data to $DUMPFILE..."

	$CMD -s adblock.py -p $PORT -w "$DUMPFILE" --set stream_large_bodies=100k
else
	[[ -d "${LOGDIR}" ]] || mkdir -p "${LOGDIR}"

	$CMD -s adblock.py -p $PORT \
		--set stream_large_bodies=100k -q --flow-detail 0 --anticache \
		--anticomp --set ssl_insecure false \
		--set ssl_verify_upstream_trusted_confdir "/etc/ssl/certs/"
fi

