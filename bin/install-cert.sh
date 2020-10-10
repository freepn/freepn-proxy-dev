#! /usr/bin/env bash
# install-cert.sh
# installs custom root CA cert to user-level nss trust store db files

certfile="${HOME}/.mitmproxy/mitmproxy-ca-cert.pem"
certname="FreePN Personal Root CA"
tgtdirs="${HOME}/.pki ${HOME}/.mozilla"
searchdirs=""


for tgt in $tgtdirs; do
	if [[ -d $tgt ]]; then
		searchdirs="${searchdirs} $tgt"
        fi
done

if [[ -n $searchdirs ]]; then
	echo "Searching for db files in: ${searchdirs}"
else
	echo "No install targets found!"
	exit 0
fi

for db8file in $(find ${searchdirs} -writable -name "cert8.db"); do
	certdir=$(dirname ${db8file})
	chkres=$(certutil -L -d dbm:${certdir} | grep -o FreePN)
	echo "Check result: $chkres"
	if ! [[ -n ${chkres} ]]; then
		echo "can install cert8.db to ${certdir}"
		#certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
	else
		echo "cert already installed in ${certdir}"
	fi
done


for db9file in $(find ${searchdirs} -writable -name "cert9.db"); do
	certdir=$(dirname ${db9file})
	chkres=$(certutil -L -d sql:${certdir} | grep -o FreePN)
	echo "Check result: $chkres"
	if ! [[ -n ${chkres} ]]; then
		echo "can install cert9.db to ${certdir}"
		#certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
	else
		echo "cert already installed in ${certdir}"
	fi
done
