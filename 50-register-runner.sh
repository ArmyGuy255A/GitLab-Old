gitlabFQDN="gitlab.domain.local"
read -p "Enter the GitLab Runner CI/CD Token: " registrationToken

docker run --rm -it -v $(pwd)/Runner/volumes/config:/etc/gitlab-runner armyguy255a/gitlab-runner:latest register \
  --non-interactive \
  --executor "docker" \
  --docker-image "gitlab/gitlab-runner-helper:ubuntu-x86_64-v14.10.2-pwsh" \
  --docker-volumes "/var/run/docker.sock" \
  --registration-token $registrationToken \
  --description "docker-runner" \
  --tag-list "docker,gitlab" \
  --run-untagged="true" \
  --locked="false" \
  --url "https://$gitlabFQDN:8443" \
  --ssh-port "8443"