
## Initialize cluster
```
./run.sh -i inventory/staging.yml playbooks/kube.yml
./run.sh -i inventory/staging.yml playbooks/kube_init.yml
./run.sh -i inventory/staging.yml playbooks/kube_join.yml
./run.sh -i inventory/staging.yml playbooks/kube_flux.yml
```

## Sealed secrets

### Install Kubeseal
```
Install kubeseal (macOS)
```
brew install kubeseal
```

Install kubeseal (Linux)
```
KUBESEAL_VERSION='' # Set this to, for example, KUBESEAL_VERSION='0.23.0'
curl -OL "https://github.com/bitnami-labs/sealed-secrets/releases/download/v${KUBESEAL_VERSION:?}/kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz"
tar -xvzf kubeseal-${KUBESEAL_VERSION:?}-linux-amd64.tar.gz kubeseal
sudo install -m 755 kubeseal /usr/local/bin/kubeseal
```

### Create cluster key pair with openssl
```
kubectl create secret generic sealed-secrets-key \
  --namespace sealed-secrets \
  --from-literal=tls.key="$(openssl genrsa 4096 | tee /tmp/sealed-secrets-key )" \
  --from-literal=tls.crt="$(openssl req -x509 -new -nodes -key /tmp/sealed-secrets-key -sha256 -days 3560 -subj '/CN=sealed-secrets/O=sealed-secrets')"
```

### Create a new sealed secret
kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets --format=yaml < secret.yaml > sealed-secret.yaml
```
