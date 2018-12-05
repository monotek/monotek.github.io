# Static Helm chart repo on Github pages

If you ever want to host a Helm chart Repo for Kubernetes apps you're not forced to use Monocular or Chartmuseum. 
You can just use Github pages to serve your charts.

* Create chart package via 
** helm package chartname
* Create index via 
** helm repo index --merge index.yaml --url https://monotek.github.io/charts .
* Move everything to your Github packe in a "charts" directoy
** mv index.yaml *.tgz /your/github/page/repo/charts
* Add your Helm repo to helm
** helm repo add monotek https://monotek.github.io/charts

