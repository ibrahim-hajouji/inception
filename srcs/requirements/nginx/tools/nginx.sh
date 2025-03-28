#!/bin/bash

# Defining where the SSL private key and the certificate signing request will be saved
prv_key="/etc/ssl/private/self-signed.key"
cs_request="/etc/ssl/certs/self-signed.csr"
certif="/etc/ssl/certs/self-signed.crt"
# the private key is used to encrypt the connection between the server and the client
# the CSR is q request sent to a certificate authority (CA) to get a certificate

# Defining the options of the certificate , these options are are verified by the CA before generating the certificate
opt="/C=MO/L=Tetouan/O=1337/OU=Student/CN=ihajouji.42.fr"
# C: Country, L: Location, O: Organization, OU: Organizational Unit, CN: Common Name (the domain name)

# Generating the private key
openssl genpkey -algorithm RSA -out "$prv_key"
# Openssl is a command line tool for cryptography and SSL/TLS functions (functions as generating keys, creating certificates, etc)
# genpkey: generates a private key
# -algorithm RSA: specifies the algorithm to use
# -out: specifies the output file

# Generating the certificate signing request
openssl req -new -key "$prv_key" -out "$cs_request" -subj "$opt"
# req: generates a certificate signing request
# -new: generates a new request
# -key: specifies the private key to use
# -subj: specifies the subject of the request
# (normally this request is sent to a CA to get a certificate but in our case we're self-signing it so we wont send it anywhere)

# Generating our self-signed certificate
openssl x509 -req -in "$cs_request" -signkey "$prv_key" -out "$certif"
# x509: generates a certificate
# -req: specifies that the input is a certificate signing request
# -in: specifies the input file
# -signkey: specifies the private key to sign the certificate with

echo "
ssl_certificate $certif;
ssl_certificate_key $prv_key;
" > /etc/nginx/snippets/self-signed.conf

# Starting the nginx server
nginx -g "daemon off;"
# -g : keeps the nginx server running in the foreground
# "daemon off;" : specifies that the server should not run as a daemon (background process)