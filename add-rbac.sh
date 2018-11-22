#!/bin/bash
name=${1:-my-user}

if [[ "${name}" == "-h" ]]; then
  echo "Usage:  add-rbac.sh [username]"
  exit 0
fi

read -p "Choose cluster role [admin, edit, view] " role

echo "This will add ${name} as a ${role} for all namespaces."
read -p "Proceed? [y/N] " confirm

if [[ "${confirm}" != "y" ]]; then
  echo "Aborting"
  exit 0
fi

kubectl create clusterrolebinding ${name} --user=${name} --clusterrole=${role}

echo "Done."
