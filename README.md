# frebib/mdns-repeater

This is a Docker image of https://github.com/kennylevinsen/mdns-repeater which
simply mirrors mDNS packets between two L2 spans.

When running this software in Docker, the container must be run in the same
network namespace as the interface that should be "bridged" to the Docker
network. In most cases, this will be `net=host` as you will most likely want to
repeat mDNS packets from a physical network interface into the Docker network.
This is built specifically with bridged networks in mind. It likely won't work
with any other configurations, probably.

Configure by setting the "host" interface `$INTERFACE` and also providing a
list of Docker networks by name or id `$NETWORKS`, and a way for the init
script to communicate with Docker (either set `$DOCKER\_HOST` or mount
/run/docker.sock into the container) to "resolve" the bridge interface names
for the networks.

### Examples

```
docker run \
  --rm --net=host \
  -e INTERFACE=eth0 \
  -e NETWORKS=bridge \
  -v /run/docker.sock:/run/docker.sock \
  frebib/mdns-repeater
```

```
version: '3'

services:
  mdns-repeater:
    image: frebib/mdns-repeater
    environment:
    - INTERFACE=eth0
    - NETWORKS=bridgo
    volumes:
    - /run/docker.sock:/run/docker.sock
    network_mode: host
    restart: unless-stopped
```
