# News Application Demo (^.^)

This news application is a fork of [Freshman-tech/news-demo](https://github.com/Freshman-tech/news-demo) and updated to be containerised
and used with CI/CD solutions.

Here's what the [completed application](https://freshman-news.herokuapp.com/)
looks like:

![demo](https://ik.imagekit.io/freshman/news-demo_MrYio9GKlzSi.png)

The code in this repo is meant to be a reference point for anyone following
along with the [tutorial](https://freshman.tech/web-development-with-go/).

## Prerequisites

- You need to have [Go](https://golang.org/dl/) installed on your computer. The
version used to test the code in this repository is **1.15.3**.

- Sign up for a [News API account](https://newsapi.org/register) and get your
free API key.

## Get started

- Clone this repository to your filesystem.

```bash
$ git clone https://github.com/sm43/news-demo
```

- Rename the `.env.example` file to `.env` and enter your News API Key.
- `cd` into it and run the following command: `go build && ./news-demo` to start the server on port 3000.
- Visit http://localhost:3000 in your browser.

## Deploying on Kubernetes Cluster

There is GitHub workflow set up which build an image and push to ghcr whenever there is code changes.


To deploy on a kubernetes cluster, you can just use the following command

Sign up for a [News API account](https://newsapi.org/register) and get your
free API key and update the confgimap in k8s dir and then apply 

```yaml
  kubectl apply -f k8s/
```

you can now expose the service `news-demo` created in `news-demo` namespace using an ingress and use the application.

If you are on OpenShift, you can create an route using the following command
```yaml
  kubectl apply -f k8s/openshift/
```
