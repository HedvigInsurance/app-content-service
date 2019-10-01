FROM swift:5.1-bionic
WORKDIR /app
RUN mkdir /app/bin

RUN \
apt-get update && \
apt-get install unzip wget curl libssl-dev zlib1g-dev gnupg2 -y && \
rm -rf /var/lib/apt/lists/*


RUN git clone https://github.com/nicklockwood/SwiftFormat
RUN cd SwiftFormat; swift build -c release; cp -f .build/release/swiftformat /usr/local/bin/swiftformat

RUN curl -o /usr/local/bin/swiftTranslationsCodegen "https://raw.githubusercontent.com/HedvigInsurance/swift-translations-codegen/master/main.swift?$(date +%s)" && chmod +x /usr/local/bin/swiftTranslationsCodegen

COPY . ./

RUN swiftTranslationsCodegen --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis
RUN swift package clean
RUN swift build -c release -Xswiftc -g
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/app-content-service serve --env production --hostname 0.0.0.0 --port $PORT
