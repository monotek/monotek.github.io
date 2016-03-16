---
layout: inner
title: 'Monthly autoupdates of letsencrypt certs'
date: 2016-03-14 15:00:00
categories: ssl letsencrypt
tags: Blog
#featured_image: 'http://placekitten.com/1500/1000'
#lead_text: 'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Expedita maiores quisquam id sunt, a architecto molestias velit, distinctio quidem non, nostrum provident quibusdam enim. Neque ipsam temporibus commodi facere minima.'
---

<http://letsencrypt.org< is cool, because it provides SSL certs for all of your domains for free! The only thing which is a bit challenging is that you have to renew your certs every 3 months. I made a script, monthkly triggered by cron, which does this for you.
\\
This script asumes you're using nginx webserver (which is reloaded by the script after creating new certs). 


letsencrypt-renew.sh
====================

~~~
#!/bin/bash
#
# letsencrypt renew
#

#config
LETSENCRYPT_DIR="/root/letsencrypt"
LETSENCRYPT_CERTS="/etc/letsencrypt/live"
NGINX_CERTS="/etc/nginx/ssl"
DOMAINS="andre-bauer.org uplink23.net pma.andre-bauer.org"

# functions
function actionstart (){
    echo -e "\n`date '+%d.%m.%G %H:%M:%S'` - ${1}"
}

function exitcode (){
    if [ "$?" = 0 ]; then
        echo "`date '+%d.%m.%G %H:%M:%S'` - ${1} - ok "
    else
        echo "`date '+%d.%m.%G %H:%M:%S'` - ${1} - not ok "
        let ERROR_COUNT=ERROR_COUNT+1
    fi
}

# script
actionstart "create ${NGINX_CERTS} dir"
test -d ${NGINX_CERTS} || mkdir -p ${NGINX_CERTS}
exitcode "create ${NGINX_CERTS} dir"

for DOMAIN in ${DOMAINS}; do
    if [ "$(echo ${DOMAIN} | awk -F . '{print NF-1}')" -gt "1" ]; then
    actionstart "create cert for ${DOMAIN} without www subdomain"
    ${LETSENCRYPT_DIR}/letsencrypt-auto certonly --duplicate --webroot-path /var/www/${DOMAIN}/html/ --webroot -d ${DOMAIN}
    exitcode "create cert for ${DOMAIN} without www subdomain"
    else
    actionstart "create cert for ${DOMAIN} including www sub domain"
    ${LETSENCRYPT_DIR}/letsencrypt-auto certonly --duplicate --webroot-path /var/www/${DOMAIN}/html/ --webroot -d ${DOMAIN} -d www.${DOMAIN}
    exitcode "create cert for ${DOMAIN} including www sub domain"
    fi

    SYMLINK="$(ls ${LETSENCRYPT_CERTS} | egrep "^${DOMAIN}(|-[0-9]{4})$" | tail -n 1 )"

    actionstart "create symlink ${NGINX_CERTS}/${DOMAIN} on ${LETSENCRYPT_CERTS}/${SYMLINK}"
    ln -fns  ${LETSENCRYPT_CERTS}/${SYMLINK} ${NGINX_CERTS}/${DOMAIN}
    exitcode "create symlink ${NGINX_CERTS}/${DOMAIN} on ${LETSENCRYPT_CERTS}/${SYMLINK}"
done

actionstart "nginx reload"
service nginx reload
exitcode "nginx reload"
~~~
{: .language-bash}

\\

/etc/cron.d/letsencrypt-renew
=============================
~~~
@monthly root /root/letsencrypt-renew.sh 2>&1 > /var/tmp/letsencrypt.log
~~~
