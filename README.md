# Kube-Test devops

### Building custom ArgoCD image

To add more binaries for ArgoCD as custom tooling, you need to build a custom `argocd` image; for that:

1. Update the dockerfile if needed at `kubernetes/custom-images/argocd.dockerfile`

2. Build and push the image to your container registry

```
docker build -t CONTAIER_REPOSITORY/argocd-custom - < argocd.dockerfile
```

`CONTAINER_REPOSITORY` can be your Docker hub registry, for example `docker build -t mydockerhub/argocd:latest ...`

### Update custom ArgoCD image

Follow the same steps for Building customer ArgoCD image, as it builds with the latest `argocd` image.

### Patch existing ArgoCD image

To force ArgoCD to use our custom image, we need to patch the `argocd-repo-server` Deployment.

In [`kubernetes/custom-images/argocd/patch.yaml`](kubernetes/custom-images/argocd/patch.yaml) you can see a patch example. To apply it use:

```
kubectl patch deployments.apps -n argocd argocd-repo-server --type json --patch-file kubernetes/custom-images/argocd/patch.yaml
```
