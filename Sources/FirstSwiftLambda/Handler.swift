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

  func handle(event request: In, context _: Lambda.Context) async throws -> Out {
    switch (request.context.http.method, request.context.http.path) {
      case (.GET, "/hello"):
        let output = try! bodyEncoder.encodeAsString(Output(hello: "world"))
        return .init(statusCode: .ok, body: output)
      case (.POST, "/hello"):
        guard let input = try? bodyDecoder.decode(Input.self, from: request.body ?? "") else {
          return .init(statusCode: .badRequest)
        }
        let output = try bodyEncoder.encodeAsString(Output(hello: input.name))
        return .init(statusCode: .ok, body: output)
      default:
        return .init(statusCode: .notFound)

    }
  }
}
