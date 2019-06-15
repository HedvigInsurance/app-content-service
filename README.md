# app-content-service

Serves content for the apps.

You need Swift 5.1 i.e Mac OS X Catalina and XCode 11.

## Develop

1. Install `swift-translations-codegen`: https://github.com/HedvigInsurance/swift-translations-codegen
2. Run `swift-translations-codegen`: `swiftTranslationsCodegen --projects '[AppContentService]' --destination 'Sources/app-content-service/Localization.swift' --exclude-objc-apis`
3. `brew install openssl@1.1`
4. `swift package update`
5. `swift package generate-xcodeproj`
6. `open app-content-service.xcodeproj`

## Add assets

1. Install `cairosvg`: `pip3 install cairosvg`
2. Add the asset as SVG to the `Public`-directory
3. Run `cairosvg -o EXAMPLE_ASSET_NAME.pdf EXAMPLE_ASSET_NAME.svg`
4. TODO Add procedure for VectorDrawables as well
