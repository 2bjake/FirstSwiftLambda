import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

let bodyDecoder = JSONDecoder()
let bodyEncoder = JSONEncoder()

@main
struct Handler: AsyncLambdaHandler {
  typealias In = APIGateway.V2.Request
  typealias Out = APIGateway.V2.Response

  struct Input: Codable {
    let name: String
  }

  struct Output: Codable {
    let hello: String
  }

  init(context: Lambda.InitializationContext) async throws { }

  func handleHello(_ name: String) throws -> Out {
    let output = try bodyEncoder.encodeAsString(Output(hello: name))
    return Out(statusCode: .ok, body: output)
  }

  func handle(event request: In, context _: Lambda.Context) async throws -> Out {
    switch (request.context.http.method, request.context.http.path) {
      case (.GET, "/hello"):
        return try handleHello("world")
      case (.POST, "/hello"):
        guard let input = try? bodyDecoder.decode(Input.self, from: request.body ?? "") else {
          return Out(statusCode: .badRequest)
        }
        return try handleHello(input.name)
      default:
        return Out(statusCode: .notFound)
    }
  }
}
