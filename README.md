# Kube-Test devops

## Testkube integration with ArgoCD

[Testkube](https://github.com/kubeshop/testkube) is a framework that allows you to build [Integration tests](https://martinfowler.com/bliki/IntegrationTest.html) that run natively in Kubernetes, without needing to expose externally the services that you're testing.

Testkube takes tests Postman or `curl` tests and creates a [Custom Resource Definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) in Kuberentes that will then create those testing resources.

As Testkube generate CRDs, we can use it with [ArgoCD](https://github.com/argoproj/argo-cd) to add the test generation to your Continuous Delivery pipeline.

Let's explore how to do it:

### Addding Testkube plugin to ArgoCD

#### 1. Build custom ArgoCD repo-server image

To add the Testkube binary for ArgoCD as a [custom tooling](https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/), and any more tools you need, you will have to build a custom `argocd` image; for that:

1. Update the dockerfile if needed at `kubernetes/custom-images/argocd.dockerfile`

2. Build and push the image to your container registry

```sh
docker build -t CONTAIER_REPOSITORY/argocd-custom - < argocd.dockerfile
```

`CONTAINER_REPOSITORY` can be your Docker hub registry, for example `docker build -t mydockerhub/argocd:latest ...`

#### 2. Patch existing ArgoCD repo-server image

To make ArgoCD use our custom image, we need to patch the `argocd-repo-server` Deployment.

In [`kubernetes/custom-images/argocd/patch.yaml`](kubernetes/custom-images/argocd/patch.yaml) you can see a patch example. To apply it use:

```sh
kubectl patch deployments.apps -n argocd argocd-repo-server --type json --patch-file kubernetes/custom-images/argocd/patch.yaml
```

#### 3. Register the plugin in ArgoCD's config management

```sh
kubectl patch -n argocd configmaps argocd-cm --patch-file kubernetes/argocd/testkube-plugin.yaml
```

#### 4. Create an ArgoCD application that uses the new plugin

You can check an example of a application that uses Testkube [here](https://github.com/aabedraba/kube-test-devops/blob/main/kubernetes/application.yaml#L20-L35)

### Update custom ArgoCD image

If you want to add more custom tools, or you need to update your custom tools to the latest versions, or just want to update the ArgoCD image itself, update the custom image's dockerfile at [`kubernetes/custom-images/argocd.dockerfile`](kubernetes/custom-images/argocd.dockerfile) and follow the same steps as for [Building custom ArgoCD image](#building-custom-argocd-image-with-testkube).

