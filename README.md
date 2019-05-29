# app-content-service

Serves content for the apps.

## Develop

1. Install `swift-translations-codegen`: https://github.com/HedvigInsurance/swift-translations-codegen
2. Run `swift-translations-codegen`: `swiftTranslationsCodegen --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis`
3. `brew install libressl`
4. `swift package update`
5. `swift package generate-xcodeproj`
6. `open app-content-service.xcodeproj`
