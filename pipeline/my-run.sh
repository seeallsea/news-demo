#!/usr/bin/env bash

# create namespace if doesn't exist
# kubectl create namespace ecoent-gcent-gcent 2>/dev/null || true

# login aries
oc login -u admin api.aries.eti.cdl.ibm.com:6443 -p admin

# install tasks for pipeline
kubectl apply -n ecoent-gcent-gcent -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/git-clone/0.5/git-clone.yaml
kubectl apply -n ecoent-gcent-gcent -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/golang-build/0.3/golang-build.yaml
kubectl apply -n ecoent-gcent-gcent -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/golang-test/0.2/golang-test.yaml
kubectl apply -n ecoent-gcent-gcent -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/buildah/0.3/buildah.yaml
kubectl apply -n ecoent-gcent-gcent -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/kubernetes-actions/0.2/kubernetes-actions.yaml

# secret to push image to registry
kubectl -n ecoent-gcent-gcent create secret generic registry-secret \
      --type="kubernetes.io/basic-auth" \
      --from-literal=username="admin" \
      --from-literal=password="admin"

# annotating registry name to secret
kubectl -n ecoent-gcent-gcent annotate secret registry-secret tekton.dev/docker-0=quay.io

# required role for service account to create/get/patch deployment
kubectl -n ecoent-gcent-gcent create role ecoent-gcent-gcent-access \
    --resource=deployment\
    --verb=create,patch,get,list

# create a serviceAccount
cat <<EOF | kubectl -n ecoent-gcent-gcent create -f-
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ecoent-gcent-gcent
  namespace: ecoent-gcent-gcent
secrets:
  - name: registry-secret
EOF

# role binding to attach role to serviceAccount
kubectl -n ecoent-gcent-gcent create rolebinding ecoent-gcent-gcent \
    --serviceaccount=ecoent-gcent-gcent:ecoent-gcent-gcent \
    --role=ecoent-gcent-gcent-access

# openshift specific, not required for any other kubernetes cluster
oc adm policy add-scc-to-user privileged system:serviceaccount:ecoent-gcent-gcent:ecoent-gcent-gcent

# create pipeline
kubectl create -n ecoent-gcent-gcent -f ./pipeline/01-pipeline.yaml

# create pipelineRun
# kubectl create -n ecoent-gcent-gcent -f ./pipeline/02-pipelinerun.yaml
