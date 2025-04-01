# Helium RadSecProxy Container

RADIUS messages used to authenticate users and for session accounting are transmitted unsecured and over UDP by default. By directing these messages internally in your secure network to a RadSecProxy, the UDP is then converted to a TLS protected TCP connection to the Helium Network core AAA servers.


---

## Prerequisites

- An intel based machine with Docker installed.
- The intel based machine has a private IP in your network reachable from your Aruba Mobility Controller
- ACLs or Firewalls allow Aruba Mobility Controller and Docker Container to communicate UDP on port 1812 and 1813
- ACLs or Firewalls allow container/host to reach the internet on TCP ports 2083 and 3802.


---

## Container Deployment

1. Un-zip and untar the Helium_RadSec_Docker.tag.gz file into the directory of your choice on the host machine. This will unpack the following items:
	- Dockerfile - The docker instructions on how to build the container
	- Radsecproxy.conf - The radsecproxy config file prepopulated to connect to Helium Network AAA servers
	- docker-compose.yml - file to start and stop the container as a daemon. 

```bash
# tar -xvzf  Helium_RadSec_Docker.tag.gz

2. Into the same directory copy the 3 certificates obtained from Helium Network
	- ca.pem - the root CA certificate
	- cert.pem - the user certificate
	- key.pem - the key file matched to the certificate
3. Start the container using:
```bash
# sudo docker compose up -d
4.If/when needed, stop the container using:
```bash
# sudo docker compose down
