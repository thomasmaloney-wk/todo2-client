#######################
##    Dart Stage     ##
#######################
FROM google/dart:2.7 as build

ENV DART_VM_OPTIONS "--old-gen-heap-size=32000"
ENV BUILD_DART2JS_VM_ARGS="--old-gen-heap-size=32000"

RUN apt-get update -qq
RUN apt-get update && apt-get install -y \
        # Used to install Chrome
        wget \
        && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
        echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
        apt-get -qq update && apt-get -qq install -y google-chrome-stable && \
        mv /usr/bin/google-chrome-stable /usr/bin/google-chrome && \
        sed -i --follow-symlinks -e 's/\"\$HERE\/chrome\"/\"\$HERE\/chrome\" --no-sandbox/g' /usr/bin/google-chrome && \
        google-chrome --version

ARG GIT_COMMIT
ARG GIT_BRANCH

## Github Credentials
ARG GIT_SSH_KEY
RUN git config --global url.git@github.com:.insteadOf https://github.com/
RUN mkdir ~/.ssh; ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
RUN chmod -R 700 ~/.ssh; echo "${GIT_SSH_KEY}" > ~/.ssh/id_rsa; chmod 600 ~/.ssh/id_rsa
RUN eval "$(ssh-agent -s)" && ssh-add ~/.ssh/id_rsa

# Install global tools
RUN pub global activate webdev ^2.0.0

# Build Environment Vars
WORKDIR /build/
COPY . /build/

## Fetch Dependencies
RUN timeout 10m pub get

## Lint Project
RUN pub run over_react_format:bootstrap --check
RUN pub run dart_dev format --check
RUN pub run dart_dev analyze

# Tests
RUN pub run dart_dev test --release

# Docs
# Disabled because it is currently extremely slow to generate docs on Dart 2. See this issue:
# https://github.com/dart-lang/dartdoc/issues/1943
# RUN dartdoc
# RUN cd doc/api && tar -zcvf api.tar.gz * && cd ../..

## Build App
RUN pub run build_runner build --delete-conflicting-outputs web --release -o build

## Artifacts
# ARG BUILD_ARTIFACTS_DOCUMENTATION=/build/doc/api/api.tar.gz
ARG BUILD_ARTIFACTS_AUDIT=/build/pubspec.lock

#######################
##     App Stage     ##
#######################
FROM amazonlinux:2

# Update uid and guid of nobody to be 65534 and not the image's default of 99
# This is done to make the uid and guid match the uid/guid specified in the runAsUser when the
# container is run in k8s.
# This should always happen before any chowns or chmods; it makes sense for it to be the first set of commands run.
RUN sed -i 's/nobody:x:99:99/nobody:x:65534:65534/g' /etc/passwd
RUN sed -i 's/nobody:x:99:/nobody:x:65534:/g' /etc/group

WORKDIR /todo2-client

# Install Nginx
# Add the official nginx.org repo to pull from
# base64-encoded key from http://nginx.org/packages/keys/nginx_signing.key
ENV NGINX_REPO_KEY=LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tClZlcnNpb246IEdudVBHIHYyLjAuMjIgKEdOVS9MaW51eCkKCm1RRU5CRTVPTW1JQkNBRCtGUFlLR3JpR0dmN05xd0tmV0M4M2NCVjAxZ2FiZ1ZXUW1aYk1jRnplVytoTXNneEgKVzZpaW1EMFJzZlo5b0ViZkpDUEcwQ1JTWjdwcHE1cEthbVlzMitFSjhRMnlzT0ZISHdwR3JBMkM4enlOQXM0SQpReG5aWkliRVRnY1N3RnREdW4wWGlxUHdQWmd5dVhWbTlQQWJMWlJiZkJ6bTh3Ui8zU1d5Z3FaQkJMZFFrNVRFCmZEUitFbnkvTTFSVlI0eENsRUNPTkY5VUJCMmVqRmRJMUxENDVBUGJQMmhzTi9waUZCeVUxdDd5SzJncEZ5UnQKOTdXekdIbjlNVjUvVEw3QW1SUE00cGNyM0phY210Q254WGVDWjhuTHFlZG9TdUhGdWh3eURubEFidThJMTZPNQpYUnJmemhySFJKRk0xSm5JaUdtelppNnpCdkgwSXRmeVg2dHRBQkVCQUFHMEtXNW5hVzU0SUhOcFoyNXBibWNnCmEyVjVJRHh6YVdkdWFXNW5MV3RsZVVCdVoybHVlQzVqYjIwK2lRRStCQk1CQWdBb0Foc0RCZ3NKQ0FjREFnWVYKQ0FJSkNnc0VGZ0lEQVFJZUFRSVhnQVVDVjJLMStBVUpHQjRmUVFBS0NSQ3I5YjJDZTltL1lsb2FCLzlYR3JvbAprb2NtN2wvdHNWamFCUUN0ZVhLdXdzbTRYaEN1QVE2WUF3QTFMMVVoZUdPRy9hYTJ4SnZyWEU4WDMydGdjVGpyCktvWW9YV2NkeGFGamxYR1R0NmpWODVxUmd1VXp2TU94eFNFTTJEbjExNWV0TjlwaVBsMFp6KzRya3g4KzJ2SkcKRitlTWxydVBYZy96ZDg4TnZ5THE1Z0dIRXNGUkJNVnVmWW1IdE5mY3A0b2tDMWtsV2lSSVJTZHA0UVkxd2RyTgoxTysvb0NUbDhCenk2aGNIakxJcTNhb3VtY0x4TWp0Qm9jbGMvNU9UaW9MRHdTRGZWeDdyV3lmUmhjQnpWYndECm9lL1BEMDhBb0FBNmZ4WHZXalN4eStkR2hFYVhvVEhqa0Niei9sNk54ckszSkZ5YXVEZ1U0SzRNeXRzWjFIRGkKTWdNVzhoWlh4c3pvSUNUVGlRRWNCQkFCQWdBR0JRSk9Ua2VsQUFvSkVLWlAxYkY2Mnptbzc5b0gvMVhEYjI5UwpZdFdwK01USlRQRkV3bFdSaXlSdURYeTN3QmQvQnB3QlJJV2ZXek1zMWduQ2pOamswRVZCVkdhMmdydnk5SnR4CkpLTWQ2bC9QV1hWdWNTdCtVLytHTzhyQmt3MTRTZGhxeGFTMmwxNHY2Z3lNZVVyU2JZM1hmVG9HZndIQzRzYS8KVGhuOFg0akZhUTJYTjVkQUl6SkdVMXM1SkEwdGpFelV3Q25tcktteU1sWFphb1FWcm1PUkdqQ3VIMEkwYUFGawpSUzBVdG5COUhQcHhoR1ZiczI0eFhaUW5aRE5iVVFldWxGeFM0dVAzT0xEQkFlQ0hsK3Y0dC91b3RJYWQ4djZKClNPOTN2YzFldklqZTZsZ3VFODFISG1Kbjlub3hQSXR2T3ZTTWIyeVBzRThtSDRjSkhSVEZOU0VoUFc2Z2htbGYKV2E5WndpVlg1aWd4Y3ZhSVJnUVFFUUlBQmdVQ1RrNWIwZ0FLQ1JEczhPa0xMQmNnZzFHK0FLQ25hY0xiLytXNgpjZmxpclVJRXhnWmRVSnFvb2dDZU5QVndYaUhFSVZxaXRoQU0xcGRZL2djYVFabUlSZ1FRRVFJQUJnVUNUazVmCllRQUtDUkNwTjJFNXBTVEZQbk5XQUo5Z1VvenlpUys5amYyckp2cW1KU2VXdUNnVlJ3Q2NDVUZoWFJDcFFPMlkKVmEzbDNXdUIrcmdLanNRPQo9RVdXSQotLS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg==
RUN echo $NGINX_REPO_KEY | base64 --decode > /tmp/nginx_signing.key
RUN rpm --import /tmp/nginx_signing.key && \
    yum install -y yum-utils && \
    yum-config-manager --add-repo=http://nginx.org/packages/mainline/centos/7/x86_64/ && \
    yum remove -y yum-utils && \
    yum install -y \
    # `gettext` is needed to run `envsubst` in `start_nginx.sh`
    gettext \
    nginx-1.17.9 && \
    rm -rf /var/cache/yum

## Set Permissions
RUN chown -R nobody:nobody /todo2-client && \
    chmod 755 /todo2-client

## Copy over files from build
COPY --from=build /build/build/ /todo2-client/build
#COPY ./config /todo2-client/config
COPY ./pubspec.yaml /todo2-client
COPY ./nginx.conf /todo2-client
COPY ./scripts/image/run-app.sh /todo2-client

## Set Permissions on Dart Files
RUN find ./ -type f -name "*.dart" -exec chmod 644 {} \;
RUN find ./ -type f -name "*.js" -exec chmod 644 {} \;
RUN find ./ -type d -exec chmod 755 {} \;

# Make sure the nobody user (and therefore nginx) can access what it needs
RUN mkdir -p /var/cache/nginx/ && \
    chown -R nobody:nobody /var && \
    mkdir -p /todo2-client/build/web/config/ && \
    chown -R nobody:nobody /todo2-client/build/web/config/ && \
    chown -R nobody:nobody /etc/nginx

# Update Packages for Security Compliance
# https://wiki.atl.workiva.net/display/SECURITY/Security+Requirements+for+Building+Containers#SecurityRequirementsforBuildingContainers-PackageUpdating
ARG BUILD_ID
RUN yum update -y --exclude=nginx && \
    yum upgrade -y --exclude=nginx && \
    yum autoremove -y && \
    yum clean all && \
    rm -rf /var/cache/yum
RUN nginx -v

USER nobody
## Startup Command
CMD [ "sh", "/todo2-client/run-app.sh" ]