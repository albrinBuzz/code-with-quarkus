FROM ubuntu:latest
LABEL authors="cris"

ENTRYPOINT ["top", "-b"]