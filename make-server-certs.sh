domain="domain.local"
localCertDir="/home/toor/GitLab/certificates"
server1="gitlab"
gitlabRunnerCertPath="/var/lib/docker/volumes/gitlab_gitlab-runner-config/_data/certs"
gitlabCertPath="/var/lib/docker/volumes/gitlab_gitlab-config/_data/ssl"

mkdir $localCertDir

#Create the server cert

#create the cert key
openssl ecparam -out $localCertDir/$server1.key -name prime256v1 -genkey

#create the CSR
openssl req -new -sha256 -nodes -key $localCertDir/$server1.key -subj "/C=US/ST=WA/L=EN/O=Domain Local/CN=gitlab.domain.local" -out $localCertDir/$server1.csr

#Generate the cert from the CSR and sign it with the CA's root key
openssl x509 -req -extfile <(printf "subjectAltName=DNS:gitlab.domain.local") -in $localCertDir/$server1.csr -CA $localCertDir/$domain.crt -CAkey $localCertDir/$domain.key -CAcreateserial -out $localCertDir/$server1.crt -days 365 -sha256

#Verify the cert
openssl x509 -in $localCertDir/$server1.crt -text -noout

#Add the CA to the Cert
cat $localCertDir/$domain.crt >> $localCertDir/$server1.crt
