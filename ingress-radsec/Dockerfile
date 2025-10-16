FROM freeradius/freeradius-server:latest

COPY proxy.conf /etc/raddb/proxy.conf

COPY meraki-ca.pem /etc/raddb/certs/meraki-ca.pem

COPY tls /etc/raddb/sites-available/tls

RUN ln -s /etc/raddb/sites-available/tls /etc/raddb/sites-enabled

RUN chown freerad:freerad /etc/freeradius/certs/client.pem
