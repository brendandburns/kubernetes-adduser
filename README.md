# An easy to use script for adding users to a kubernetes cluster

## Running via docker

```
docker run -v $HOME/.kube:/root/.kube -v $PWD:/add-user -it brendanburns/kubernetes-adduser:v1 bash
# In the docker container
add-user.sh ${SOME_USER_NAME}
add-rbac.sh ${SOME_USER_NAME}
```
