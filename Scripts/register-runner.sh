# Copy the GitLab Server Self-signed certificate to the runner
gitlabCert="/var/lib/docker/volumes/gitlab_gitlab-config/_data/ssl/gitlab.domain.local.crt"
# gitlabCert="/var/lib/docker/volumes/gitlab_gitlab-config/_data/ssl/ca.crt"
gitlabRunnerCertPath="/var/lib/docker/volumes/gitlab_gitlab-runner-config/_data/certs"
# gitlabRunnerCertPath="/var/lib/docker/volumes/gitlab_gitlab-runner-home/_data/certs"
gitlabDomain="gitlab.domain.local"
gitlabSslPort="8443"

cp $gitlabCert $gitlabRunnerCertPath

# openssl s_client -showcerts -connect $gitlabDomain:$gitlabSslPort -servername $gitlabDomain < /dev/null 2>/dev/null | openssl x509 -outform PEM > $gitlabRunnerCertPath/$gitlabDomain.crt
openssl s_client -showcerts -connect $gitlabDomain:$gitlabSslPort -servername $gitlabDomain < /dev/null 2>/dev/null | openssl x509 -outform PEM > $gitlabRunnerCertPath/ca.crt
cd $gitlabRunnerCertPath
ls $gitlabRunnerCertPath
cat $gitlabRunnerCertPath/$gitlabDomain.crt

# echo | openssl s_client -CAfile /etc/gitlab-runner/certs/gitlab.example.com.crt -connect gitlab.example.com:443 -servername gitlab.example.com

# Restart the container
docker container restart gitlab-gitlab-runner-1
# Register the runner
docker run --rm -it -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register

docker run --rm -it -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest restart

# docker run --rm -it -v gitlab-runner-home:/home/gitlab-runner -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register \

docker run --rm -it -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register \
  --non-interactive \
  --executor "docker" \
  --url "https://gitlab.domain.local:8443/" \
  --tls-ca-file "/etc/gitlab-runner/certs/ca.crt" \
  --registration-token "1UtEETXPunSvEPesC8H2" \
  --description "docker-runner" \
  --maintenance-note "Free-form maintainer notes about this runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"