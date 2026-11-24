FROM ruby:4.0.10-slim-trixie

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        jq \
        libffi-dev \
        libsqlite3-dev \
        libssl-dev \
        libvips-dev \
        libyaml-dev \
        sqlite3 \
        sudo \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Gems install into a folder the non-root vscode user can write, so `bundle install`
# works in the container. The ruby image runs as root and installs gems under /usr/local.
ENV GEM_HOME=/usr/local/bundle BUNDLE_PATH=/usr/local/bundle BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:$PATH
RUN mkdir -p /usr/local/bundle && chmod -R a+rwX /usr/local/bundle
RUN gem install rails -v 8.1.4.1 --no-document
