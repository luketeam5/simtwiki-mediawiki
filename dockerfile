FROM mediawiki:1.46

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/extensions

RUN curl -fsSL \
        https://github.com/wikimedia/mediawiki-extensions-Cargo/archive/3.9.4.tar.gz \
        | tar -xz \
    && mv mediawiki-extensions-Cargo-3.9.4 Cargo

# Page Forms - stable release
RUN curl -fsSL \
        https://github.com/wikimedia/mediawiki-extensions-PageForms/archive/6.0.11.tar.gz \
        | tar -xz \
    && mv mediawiki-extensions-PageForms-6.0.11 PageForms

# Extensions tied more closely to the MediaWiki release
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

# We don't need git/curl at runtime.
RUN apt-get purge -y --auto-remove git curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html