FROM spritsail/alpine

WORKDIR /tmp

RUN apk --no-cache add git gcc make musl-dev && \
    git clone https://github.com/kennylevinsen/mdns-repeater.git . && \
    make mdns-repeater

FROM spritsail/alpine

COPY --from=0 /tmp/mdns-repeater /usr/bin
RUN apk --no-cache add docker-cli

CMD exec mdns-repeater -f $INTERFACE $(for network in $NETWORKS; do docker inspect $network -f '{{ printf "br-%.12s" .ID }}'; done)
