import Foundation
import Graphiti
import Vapor
import SwiftGraphQLServer

let schema = try Schema<Void, Void, MultiThreadedEventLoopGroup> { schema in
    try schema.query { query in
        try HedvigColor.build(schema, query)
        try Icon.build(schema, query)
        try Localization.Locale.build(schema, query)
        try CommonClaim.build(schema, query)
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

try GraphQLServer(schema: schema).run(router: router)

try app.run()

