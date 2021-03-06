---
title: 'Static Helm chart repo on Github pages'
date: 2018-12-05 15:00:00
categories: ["helm", "chart", "repo", "kubernetes"]
tags: ["Blog"]
type: 'post'
---

If you ever want to host a Helm chart Repo for Kubernetes apps you're not forced to use Monocular or Chartmuseum.
You can just use Github pages to serve your charts.

* Create chart package via

```
helm package chartname
```

* Create index via:

```
helm repo index --merge index.yaml --url https://monotek.github.io/charts .
```

* Move everything to your Github packe in a "charts" directoy:

```
mv index.yaml *.tgz /your/github/page/repo/charts
```

* Add your Helm repo to helm:

```
helm repo add monotek https://monotek.github.io/charts
```

* If you want to have your repo files browsable, go to the charts directory and enter:

```
perl -e 'print "<html><body><ul>"; while(<>) { chop $_; print "<li><a href=\"./$_\">$_</a></li>";} print "</ul></body></html>"' > index.html
```
