---
layout: inner
title: 'Mailreports from Kibana pages via PhantomJS'
date: 2016-11-07 19:00:00
categories: mail kibana phantomjs reports skedler mailreports OTRS
tags: Blog
---

A lot of people ask for mail reports in <https://www.elastic.co/products/kibana> but this feature does not exist. At least not in the oss version. As i also had these requirement for an OTRS installation and don't wanted to use expensive software like Skedler, i decided to create an own solution.

It depends on PhantomJS, which can be found on <http://phantomjs.org/>. PhantomJS is a headless WebKit browser scriptable with a JavaScript API. So you're able to browse (Kibana) websites and save them to JPG. These JPGs can be send via mail easily.

First of all you have to get a phantomjs binary somewhere. If you want to buil itd yourselv follow instructions of <http://phantomjs.org/build.html>.

Now get the mail report scripts from my GitHub page. You can find everything here: <https://github.com/monotek/kibana-mailreports>

You have to edit the kibana-mailreports.sh and urls.conf files to get it work. The urls.conf is the file which defines the reports, which are send to the mail adresses you want. Columns are separated by ";;;". It will loook like:

- your@mail.com;;;OTRS-Reports;;;1w/w;;;Postmaster*;;;1920*1500px;;;last week

The fields are:
---------------
- Mail address where report is send to
- Kibana dashboard which should be used
- Time interval of the report
- Search string in Kibana dashboard
- Resolution of JPG
- Human readable time string for use in the report mail

You can run the kibana-mailreports.sh script manually to check if everything works. If so just create the following cronjob, which triggers this weekly.

- @weekly root /opt/kibana-mailreports/kibana-mailreports.sh 2>&1 > /var/tmp/kibana-mailreports.log

Thats it. Have fun getting weekly mail reports from Kibana! :-)
