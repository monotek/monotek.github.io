---
layout: inner
title: 'Monthly autoupdates of letsencrypt certs'
date: 2016-03-16 15:00:00
categories: ssl letsencrypt
tags: Blog
#featured_image: 'https://letsencrypt.org/images/letsencrypt-logo-horizontal.svg'
#featured_video: 'https://www.youtube.com/watch?v=Bt9zSfinwFA'
#lead_text: ' bla bla'
---

<http://letsencrypt.org> is cool, because it provides SSL certs for all of your domains for free! The only thing which is a bit challenging is that you have to renew your certs every 3 months. I made a script which, monthly triggered by cron, can do this for you.\\
\\
This script assumes you're using nginx webserver (which is reloaded by the script after recreating certs) and that your domains are located in "/var/www/domain.name/html" directory. Your letsenrypt installation is configured via the "LETSENCRYPT_DIR" var. The certs are linked to the directory configured via "WEBSERVER_CERTS" var which is used to have a static symlink that points to your cert without getting renamed so you can keep your webserver config untouched.\\
\\
The "DOMAIN" var can have any FQDN. If its a normal domain the cert is also created for the "www" subdomain automaticly. If its a subdomain like "blog.andre-bauer.org" this step is skipped.

/etc/letsencrypt/letsencrypt-renew.sh
====================

~~~
#!/bin/bash
#
# letsencrypt renew
#

#config
LETSENCRYPT_DIR="/root/letsencrypt"
LETSENCRYPT_CERTS="/etc/letsencrypt/live"
WEBSERVER_CERTS="/etc/nginx/ssl"
DOMAINS="andre-bauer.org blog.andre-bauer.org"

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
actionstart "create ${WEBSERVER_CERTS} dir"
test -d ${WEBSERVER_CERTS} || mkdir -p ${WEBSERVER_CERTS}
exitcode "create ${WEBSERVER_CERTS} dir"

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

    actionstart "create symlink ${WEBSERVER_CERTS}/${DOMAIN} on ${LETSENCRYPT_CERTS}/${SYMLINK}"
    ln -fns  ${LETSENCRYPT_CERTS}/${SYMLINK} ${WEBSERVER_CERTS}/${DOMAIN}
    exitcode "create symlink ${WEBSERVER_CERTS}/${DOMAIN} on ${LETSENCRYPT_CERTS}/${SYMLINK}"
done

actionstart "nginx reload"
service nginx reload
exitcode "nginx reload"
~~~
{: .language-bash}

You can run this script manually to check if everything works. If so just create the following cronjob, which triggers this monthly. 


/etc/cron.d/letsencrypt-renew
=============================

~~~
@monthly root /etc/letsencrypt/letsencrypt-renew.sh 2>&1 > /var/tmp/letsencrypt.log
~~~

Thats it. Have fun. Never care about renewing you SSL certs again :-)