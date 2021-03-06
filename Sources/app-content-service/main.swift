import Foundation
import Graphiti
import Vapor
import SwiftGraphQLServer
import Backtrace

Backtrace.install()

let schema = Schema<AppContentAPI, Request> {
    Icon.build()
    HedvigColor.build()
    Localization.Locale.build()
    CommonClaim.build()
    News.build()
    Welcome.build()
    
    Query {
        Field(.commonClaims, at: AppContentAPI.getCommonClaims)
        Field(.news, at: AppContentAPI.getNews)
        Field(.welcome, at: AppContentAPI.getWelcome)
    }
}

struct Health: Content {
    let status = "pass"
}

public func routes(_ r: Routes, _ c: Container) throws {
    r.get("health") { req -> Health in
        Health()
    }
    
    let api = AppContentAPI()
    
    try GraphQLServer(
        schema: schema,
        getContext: { $0 },
        getRootValue: { req in
            if let graphqlRequest = req.body.string {
                print(graphqlRequest)
            }
            return api
        }
    ).run(r)
}

try Application(environment: .detect(), configure: { (services: inout Services) in
    services.register(AssetsMiddleware.self) { c in
        return try .init(
            publicDirectory: c.make(DirectoryConfiguration.self).publicDirectory,
            fileio: c.make()
        )
    }
    
    services.register(MiddlewareConfiguration.self) { c in
        var middleware = MiddlewareConfiguration()
        try middleware.use(c.make(AssetsMiddleware.self))
        try middleware.use(c.make(ErrorMiddleware.self))
        return middleware
    }
        
    services.register(HTTPServer.Configuration.self) { c in
        let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8080")!
        
        switch c.environment {
        case Environment.production:
            return HTTPServer.Configuration.init(hostname: "0.0.0.0", port: port)
        case Environment.development:
            return HTTPServer.Configuration.init(hostname: "127.0.0.1", port: port)
        default:
            return HTTPServer.Configuration.init(hostname: "0.0.0.0", port: port)
        }
    }
    
    services.extend(Routes.self) { r, c in
        try routes(r, c)
    }
}).run()


