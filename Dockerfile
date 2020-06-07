FROM debian:10

RUN apt-get update && apt-get install busybox && apt-get clean
RUN busybox wget -q http://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && \
    mv cfssl_linux-amd64 /usr/bin/cfssl && \
    chmod a+x /usr/bin/cfssl && \
    busybox wget -q http://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && \
    mv cfssljson_linux-amd64 /usr/bin/cfssljson && \
    chmod a+x /usr/bin/cfssljson && \
    busybox wget -q https://storage.googleapis.com/kubernetes-release/release/`busybox wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/kubectl && \
    chmod a+x /usr/bin/kubectl

COPY add-user.sh /usr/bin/add-user.sh
COPY add-rbac.sh /usr/bin/add-rbac.sh
RUN chmod a+x /usr/bin/add-user.sh && chmod a+x /usr/bin/add-rbac.sh
