FROM argoproj/argocd:latest

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests 
# (e.g. curl, awscli, gpg, sops)
RUN apt-get update && \
  apt-get install -y \
  wget && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  mkdir testkube && mkdir .testkube && \
  echo "{}" > .testkube/config.json && \
  cd testkube && wget -O- https://github.com/kubeshop/testkube/releases/download/v0.9.17/testkube_0.9.17_Linux_x86_64.tar.gz | tar -xzvf - && \
  mv kubectl-testkube /usr/local/bin/testkube && \
  chmod +x /usr/local/bin/testkube

# Switch back to non-root user
USER 999