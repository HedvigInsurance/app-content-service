FROM vapor/swift:5.1-bionic
WORKDIR /app
RUN mkdir /app/bin

RUN \
apt-get update && \
apt-get install unzip wget curl libssl-dev zlib1g-dev gnupg2 -y && \
rm -rf /var/lib/apt/lists/*

RUN curl https://swift.org/keys/all-keys.asc | gpg2 --import -

ENV SWIFT_BRANCH=swift-5.1-branch \
    SWIFT_PLATFORM=ubuntu18.04 \
    SWIFT_VERSION=5.1-DEVELOPMENT-SNAPSHOT-2019-06-17-a

# Install Swift toolchain for ubuntu
RUN SWIFT_ARCHIVE_NAME=swift-$SWIFT_VERSION-$SWIFT_PLATFORM && \
    SWIFT_URL=https://swift.org/builds/$SWIFT_BRANCH/$(echo "$SWIFT_PLATFORM" | tr -d .)/swift-$SWIFT_VERSION/$SWIFT_ARCHIVE_NAME.tar.gz && \
    curl -O $SWIFT_URL && \
    curl -O $SWIFT_URL.sig && \
    gpg2 --verify $SWIFT_ARCHIVE_NAME.tar.gz.sig && \
    tar -xvzf $SWIFT_ARCHIVE_NAME.tar.gz --directory / --strip-components=1 && \
    LIB_CLANG=/usr/lib/clang/7.0.0 && diff -r $LIB_CLANG /usr/lib/lldb/clang && rm -rf /usr/lib/lldb/clang && ln -sfr $LIB_CLANG /usr/lib/lldb/clang && \
    rm -rf $SWIFT_ARCHIVE_NAME* /tmp/* /var/tmp/* && \
    chmod -R o+r /usr/lib/swift

# Print Installed Swift Version
RUN swift --version

RUN curl -LOk -o ./0.40.5.zip "https://github.com/nicklockwood/SwiftFormat/archive/0.40.5.zip"
RUN unzip ./0.40.5.zip
RUN curl -o /usr/local/bin/swiftTranslationsCodegen "https://raw.githubusercontent.com/HedvigInsurance/swift-translations-codegen/master/main.swift?$(date +%s)" && chmod +x /usr/local/bin/swiftTranslationsCodegen

COPY . ./

RUN swiftTranslationsCodegen --swiftformat-path ./SwiftFormat-0.40.5/CommandLineTool/swiftformat --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis
RUN swift package clean
RUN swift build -c release
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/app-content-service serve --env production --hostname 0.0.0.0 --port 8080
