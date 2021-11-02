#!/bin/bash

csr_name="my-client-csr"
name="${1:-my-user}"
cert_name="${name}-client"

if ! which cfssl; then
  echo "Can't find the cfssl tool, please install from https://pkg.cfssl.org/"
  exit 1
fi

if ! which cfssljson; then
  echo "Can't find the cfssljson tool, please install from https://pkg.cfssl.org/"
  exit 1
fi

echo "Generating signing request."
perl -p -e "s/%USER%/${name}/" cfssl.json.tmpl > cfssl.json

cfssl genkey cfssl.json | \
    cfssljson -bare ${cert_name} 

cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: ${csr_name} 
spec:
  signerName: kubernetes.io/kube-apiserver-client
  groups:
  - system:authenticated
  request: $(cat ${cert_name}.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - client auth
EOF

echo
echo "Approving signing request."
kubectl certificate approve ${csr_name}

echo
echo "Downloading certificate." 
kubectl get csr ${csr_name} -o jsonpath='{.status.certificate}' \
    | base64 --decode > ${cert_name}.crt

echo
echo "Cleaning up"
kubectl delete csr ${csr_name}
rm ${cert_name}.csr
rm cfssl.json

echo
echo "Add the following to the 'users' list in your kubeconfig file:"
echo "- name: ${name}"
echo "  user:"
echo "    client-certificate: ${PWD}/${cert_name}.crt"
echo "    client-key: ${PWD}/${cert_name}-key.pem"
echo
echo "Next you may want to add a role-binding for this user."


