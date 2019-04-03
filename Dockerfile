FROM swift:4.2
WORKDIR /app
RUN mkdir /app/bin
COPY . ./
RUN swift package clean
RUN swift build -c release
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/app-content-service serve -e prod -b 0.0.0.0
