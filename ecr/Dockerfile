FROM amazon/aws-cli:latest

RUN yum install -y git

COPY git-diff.sh /usr/local/bin/git-diff
RUN chmod +x /usr/local/bin/git-diff

ENTRYPOINT [ "/bin/sh" ]

CMD ["-c", "git-diff"]