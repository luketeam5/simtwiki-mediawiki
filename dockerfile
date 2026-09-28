FROM mediawiki:1.46

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        bzip2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

# Cargo
RUN curl -fsSL \
        https://github.com/wikimedia/mediawiki-extensions-Cargo/archive/3.9.4.tar.gz \
        | tar -xz \
    && mv mediawiki-extensions-Cargo-3.9.4 Cargo

# Page Forms
RUN curl -fsSL \
        https://github.com/wikimedia/mediawiki-extensions-PageForms/archive/6.0.11.tar.gz \
        | tar -xz \
    && mv mediawiki-extensions-PageForms-6.0.11 PageForms

# Popups + CodeMirror for MW 1.46
RUN git clone \
        --depth 1 \
        --branch REL1_46 \
        https://gerrit.wikimedia.org/r/mediawiki/extensions/Popups \
        Popups \
    && git clone \
        --depth 1 \
        --branch REL1_46 \
        https://gerrit.wikimedia.org/r/mediawiki/extensions/CodeMirror \
        CodeMirror

# MediaWiki Language Extension Bundle 2026.09
RUN curl -fsSL \
        https://translatewiki.net/mleb/MediaWikiLanguageExtensionBundle-2026.09.tar.bz2 \
        -o /tmp/mleb.tar.bz2 \
    && echo "c854e060e6cbaa6ff8c55ed63f59f94a6b8aaaf810813f2a14734b221a50a605  /tmp/mleb.tar.bz2" \
        | sha256sum -c - \
    && mkdir -p /tmp/mleb \
    && tar -xjf /tmp/mleb.tar.bz2 -C /tmp/mleb \
    && cp -a /tmp/mleb/extensions/. /var/www/html/extensions/ \
    && rm -rf /tmp/mleb /tmp/mleb.tar.bz2

RUN apt-get purge -y --auto-remove git curl bzip2 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html