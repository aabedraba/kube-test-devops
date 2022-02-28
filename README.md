# Kube-Test devops

### Building custom ArgoCD image

To add more binaries for ArgoCD as custom tooling, you need to build a custom `argocd` image; for that:  

1. Update the dockerfile if needed at `kubernetes/custom-images/argocd.dockerfile`

2. Build and push the image to your container registry

```
docker buildx build --platform linux/amd64 --push -t CONTAIER_REPOSITORY/custom-argocd - < argocd.dockerfile
```

`CONTAINER_REPOSITORY` can be your Docker hub registry, for example `docker buildx ... -t mydockerhub/argocd:latest ...`

### Update custom ArgoCD image

Follow the same steps for Building customer ArgoCD image, as it builds with the latest `argocd` image.