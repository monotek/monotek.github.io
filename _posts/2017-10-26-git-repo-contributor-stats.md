---
layout: inner
title: 'Git repo contributor statistics'
date: 2017-10-26 12:00:00
categories: stats git
tags: Blog
---

In one line:

* for CONTRIBUTOR in $(git log --format='%ae' | sort -u); do echo "${CONTRIBUTOR}";git log --shortstat --author="${CONTRIBUTOR}" | grep -E "fil(e|es) changed" | awk '{files+=$1; inserted+=$4; deleted+=$6} END {print "files changed: ", files, "lines inserted: ", inserted, "lines deleted: ", deleted }';done
