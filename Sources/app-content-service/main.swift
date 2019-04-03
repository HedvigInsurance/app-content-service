import Foundation
import Graphiti
import Vapor
import SwiftGraphQLServer

let schema = try Schema<Void, Void, MultiThreadedEventLoopGroup> { schema in
    try schema.query { query in
        try Icon.build(schema, query)
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

try GraphQLServer(schema: schema).run(router: router)

try app.run()

