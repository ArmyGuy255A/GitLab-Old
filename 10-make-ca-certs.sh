domain="domain.local"
localCertDir="./certificates"

mkdir $localCertDir

#Create the root key
openssl ecparam -out $localCertDir/$domain.key -name prime256v1 -genkey
#Create a root cert and self-sign it
openssl req -new -nodes -sha256 -key $localCertDir/$domain.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=domain.local" -out $localCertDir/$domain.csr
#Generate the root cert
openssl x509 -req -extfile <(printf "subjectAltName=DNS:ca.domain.local") -sha256 -days 365 -in $localCertDir/$domain.csr -signkey $localCertDir/$domain.key -out $localCertDir/$domain.crt
