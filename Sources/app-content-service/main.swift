import Foundation
import Graphiti
import Vapor
import SwiftGraphQLServer

let schema = Schema<AppContentAPI, Request> {
    Icon.build()
    HedvigColor.build()
    Localization.Locale.build()
    CommonClaim.build()
    News.build()
    
    Query {
        Field(.commonClaims, at: AppContentAPI.getCommonClaims)
        Field(.news, at: AppContentAPI.getNews)
    }
}

var services = Services.default()
services.register(AssetsMiddleware.self)

var middlewares = MiddlewareConfig.default()
middlewares.use(AssetsMiddleware.self)

services.register(middlewares)

let app = try Application(config: Config.default(), environment: Environment.detect(), services: services)
let router = try app.make(Router.self)

struct Health: Content {
    let status = "pass"
}

router.get("health") { req -> Health in
    return Health()
}

let api = AppContentAPI()

try GraphQLServer(
    schema: schema,
    getContext: { $0 },
    getRootValue: { _ in api }
).run(router: router)

try app.run()

