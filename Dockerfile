FROM norionomura/swift:swift-5.1-branch
WORKDIR /app
RUN mkdir /app/bin

RUN \
apt-get update && \
apt-get install unzip wget curl zlib1g-dev -y && \
rm -rf /var/lib/apt/lists/*

RUN wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz
RUN tar xzvf openssl-1.1.0f.tar.gz
RUN cd openssl-1.1.0f && ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' && make && make install

RUN echo '/usr/local/lib64' >> /etc/ld.so.conf
RUN ldconfig

RUN curl -LOk -o ./0.40.5.zip "https://github.com/nicklockwood/SwiftFormat/archive/0.40.5.zip"
RUN unzip ./0.40.5.zip
RUN curl -o /usr/local/bin/swiftTranslationsCodegen "https://raw.githubusercontent.com/HedvigInsurance/swift-translations-codegen/master/main.swift?$(date +%s)" && chmod +x /usr/local/bin/swiftTranslationsCodegen

COPY . ./

RUN swiftTranslationsCodegen --swiftformat-path ./SwiftFormat-0.40.5/CommandLineTool/swiftformat --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis
RUN swift package clean
RUN swift build -c release
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/app-content-service serve -e prod -b 0.0.0.0 -p $PORT
