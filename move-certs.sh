domain="domain.local"
localCertDir="/home/toor/GitLab/certificates"
server1="gitlab"
gitlabRunnerCertPath="/var/lib/docker/volumes/runner_gitlab-runner-config/_data/certs"
gitlabCertPath="/var/lib/docker/volumes/server_gitlab-config/_data/ssl"

#rename the old certs for git GitLab Volume
mv $gitlabCertPath/gitlab.domain.local.key $gitlabCertPath/gitlab.domain.local.key.old3
mv $gitlabCertPath/gitlab.domain.local.crt $gitlabCertPath/gitlab.domain.local.crt.old3

#copy the new certs to the Server
cp $localCertDir/$server1.crt $gitlabCertPath/gitlab.domain.local.crt
cp $localCertDir/$server1.key $gitlabCertPath/gitlab.domain.local.key

#Restart the server
docker compose -f Server/docker-compose.yml down
docker compose -f Server/docker-compose.yml up -d

#copy the domain.local.crt to ca.crt on the runner
cp $localCertDir/$domain.crt $gitlabRunnerCertPath/ca.crt
cp $localCertDir/$server1.crt $gitlabRunnerCertPath/gitlab.domain.local.crt

#Restart the runner
docker compose -f Runner/docker-compose.yml down
docker compose -f Runner/docker-compose.yml up -d

# docker compose down

# docker compose up -d

# openssl s_client -connect gitlab.domain.local:8443 -servername gitlab.domain.local -showcerts

# docker logs gitlab-gitlab