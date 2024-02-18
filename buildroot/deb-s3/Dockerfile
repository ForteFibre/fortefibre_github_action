FROM ruby:3.3.0-slim-bookworm

RUN apt-get update \
    && apt-get install -y git gpg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install deb-s3

COPY /entrypoint.bash /entrypoint.bash
RUN chmod +x /entrypoint.bash

ENTRYPOINT [ "/entrypoint.bash" ]