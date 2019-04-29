FROM swift:5.0
WORKDIR /app
RUN mkdir /app/bin
COPY . ./
RUN \
apt-get update && \
apt-get install unzip wget -y && \
rm -rf /var/lib/apt/lists/*
RUN curl -LOk -o ./0.40.5.zip "https://github.com/nicklockwood/SwiftFormat/archive/0.40.5.zip"
RUN unzip ./0.40.5.zip
RUN curl -o /usr/local/bin/swiftTranslationsCodegen "https://raw.githubusercontent.com/HedvigInsurance/swift-translations-codegen/master/main.swift?$(date +%s)" && chmod +x /usr/local/bin/swiftTranslationsCodegen
RUN swiftTranslationsCodegen --swiftformat-path ./SwiftFormat-0.40.5/CommandLineTool/swiftformat --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis
RUN swift package clean
RUN swift build -c release
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/app-content-service serve -e prod -b 0.0.0.0 -p $PORT
