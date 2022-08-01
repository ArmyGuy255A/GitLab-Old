domain="domain.local"
localCertDir="./certificates"
#GITLAB
gitlabFQDN="gitlab.domain.local"
gitlabConfigVolume="./GitLab/volumes/config"
gitlabCertPath="$gitlabConfigVolume/ssl"
#RUNNER
runnerConfigVolume="./Runner/volumes/config"
runnerCertPath="$runnerConfigVolume/certs"
#REGISTRY
#VAULT
vaultFQDN="vault.domain.local"
vaultConfigVolume="./Vault/volumes/config"
vaultCertPath="$vaultConfigVolume/ssl"

# Make the cert directories (recursively)
for directory in $runnerCertPath $gitlabCertPath $vaultCertPath
do
    mkdir -p $directory
done

# #rename the old certs for git GitLab Volume
# mv $gitlabCertPath/gitlab.domain.local.key $gitlabCertPath/gitlab.domain.local.key.old
# mv $gitlabCertPath/gitlab.domain.local.crt $gitlabCertPath/gitlab.domain.local.crt.old

#copy the new certs to the GitLab Server
cp $localCertDir/$gitlabFQDN.crt $gitlabCertPath/$gitlabFQDN.crt
cp $localCertDir/$gitlabFQDN.key $gitlabCertPath/$gitlabFQDN.key

#copy the new certs to the GitLab Server
cp $localCertDir/$gitlabFQDN.crt $gitlabCertPath/$gitlabFQDN.crt
cp $localCertDir/$gitlabFQDN.key $gitlabCertPath/$gitlabFQDN.key


# #Restart the server
# docker compose -f Server/docker-compose.yml down
# docker compose -f Server/docker-compose.yml up -d

#copy the domain.local.crt to ca.crt on the runner
cp $localCertDir/$domain.crt $runnerCertPath/ca.crt
cp $localCertDir/$gitlabFQDN.crt $runnerCertPath

# #Restart the runner
# docker compose -f Runner/docker-compose.yml down
# docker compose -f Runner/docker-compose.yml up -d

# docker compose down

# docker compose up -d

# openssl s_client -connect gitlab.domain.local:8443 -servername gitlab.domain.local -showcerts

# docker logs gitlab-gitlab