FROM jekyll/jekyll:4.2.0

# RUN apk -v --update add openjdk8-jre

### Install aws-cli and dependencies
RUN apk -v --update add python3
RUN pip3 install awscli

### Install ncurses for pretty output
RUN apk -v --update add ncurses

### Copy over the entrypoint shell script
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
