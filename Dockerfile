FROM docker:18.09-dind
MAINTAINER Tom Denham <tom@projectcalico.org>

# Install our deps.
RUN apk add --update iptables ip6tables ipset iproute2 curl busybox-extras 

# Install iptables, ip6tables, iproute2, and perform glibc install as per:
# https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile
ENV GLIBC_VERSION 2.35-r1

# Download and install glibc
RUN apk add --update curl && \
  curl -Lo /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
  curl -Lo glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" && \
  curl -Lo glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" && \
  apk add --force-overwrite glibc-bin.apk glibc.apk && \
  /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
  echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
  rm -rf /var/cache/apk/* glibc.apk glibc-bin.apk

# Back-compat wrapper around the timeout command.  Earlier busybox versions
# required a -t argument so our older release brnahces still have that.
COPY ./timeout /usr/local/bin
