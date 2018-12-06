---
title: 'Monthly autoupdates of letsencrypt certs'
date: 2016-03-16 15:00:00
categories: ["ssl", "letsencrypt"]
tags: ["Blog"]
#featured_image: 'https://letsencrypt.org/images/letsencrypt-logo-horizontal.svg'
#featured_video: 'https://www.youtube.com/watch?v=Bt9zSfinwFA'
#lead_text: ' bla bla'
---

*** This is outdated. Use one of the following tools instead: ***

* https://certbot.eff.org/
* https://acme.sh
* https://github.com/hlandau/acme


Old Post:

<http://letsencrypt.org> is cool, because it provides SSL certs for all of your domains for free! The only thing which is a bit challenging is that you have to renew your certs every 3 months. I made a script which, monthly triggered by cron, can do this for you.\\
\\
This script assumes you're using nginx webserver (which is reloaded by the script after recreating certs) and that your domains are located in "/var/www/domain.name/html" directory. Your letsenrypt installation is configured via the "LETSENCRYPT_DIR" var. The certs are linked to the directory configured via "WEBSERVER_CERTS" var which is used to have a static symlink that points to your cert without getting renamed so you can keep your webserver config untouched.\\
\\
The "DOMAIN" var can have any FQDN. If its a normal domain the cert is also created for the "www" subdomain automaticly. If its a subdomain like "blog.andre-bauer.org" this step is skipped.

/etc/letsencrypt/letsencrypt-renew.sh
=====================================

Find it here: <https://github.com/monotek/letsencrypt-renew>

You can run this script manually to check if everything works. If so just create the following cronjob, which triggers this monthly.


/etc/cron.d/letsencrypt-renew
=============================

- @monthly root /etc/letsencrypt/letsencrypt-renew.sh 2>&1 > /var/tmp/letsencrypt.log

Thats it. Have fun. Never care about renewing you SSL certs again :-)
