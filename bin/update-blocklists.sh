#! /usr/bin/env bash
# update-blocklists.sh
#

#set -x

failures=0
trap 'failures=$((failures+1))' ERR

PATH=/usr/bin:/bin:/usr/sbin:/sbin
export LC_ALL=C

# environemt vars
#VERBOSE="anything"
# used to set download path relative to $HOME
CACHEPATH=${1:-.cache/freepn-proxy}
LISTDIR="${HOME}/${CACHEPATH}/blocklists"
[[ -d "${LISTDIR}" ]] || mkdir -p "${LISTDIR}"
LISTFILES="easylist easyprivacy fanboy-annoyance fanboy-social"

[[ -n $VERBOSE ]] && echo "Using path: ${LISTDIR}"

log_file="${HOME}/${CACHEPATH}/wget.log"
wget_args="--timeout=2 --waitretry=0 --tries=3 -N"

if ! [[ -n $VERBOSE ]] ; then
	wget_args="${wget_args} -o $log_file -q"
fi

[[ -n $VERBOSE ]] && echo "Using wget args: ${wget_args}"

[[ -n $VERBOSE ]] && echo "* Updating blocklists in ${LISTDIR}"

for blocklist in $LISTFILES ; do
	[[ -n $VERBOSE ]] && echo "* Checking blockfile ${blocklist}"
	wget $wget_args -P $LISTDIR https://easylist-downloads.adblockplus.org/${blocklist}.txt
done

if ((failures < 1)); then
    echo "Success"
else
    echo "$failures warnings/errors"
    exit 1
fi
