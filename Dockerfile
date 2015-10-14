FROM alpine:3.2

RUN apk add --update iptables && rm -rf /var/cache/apk/*
ADD https://raw.githubusercontent.com/docker/docker/master/hack/dind /usr/local/bin/ 
ADD https://raw.githubusercontent.com/docker-library/docker/master/1.8/dind/dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*

VOLUME /var/lib/docker
EXPOSE 2375

# Requires an executable docker binary to be volume mounted into the PATH

ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []
