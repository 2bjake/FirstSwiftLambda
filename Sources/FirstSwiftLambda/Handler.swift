import AWSLambdaRuntime
import AWSLambdaEvents
import Foundation

private let bodyDecoder = JSONDecoder()
private let bodyEncoder = JSONEncoder()

@main
struct Handler: AsyncLambdaHandler {
  typealias In = APIGateway.V2.Request
  typealias Out = APIGateway.V2.Response

  private struct Input: Codable {
    let name: String
  }

  private struct Output: Codable {
    let hello: String
  }

  init(context: Lambda.InitializationContext) async throws { }

  func handle(event: In, context: Lambda.Context) async -> Out {
    do {
      return try await handleInternal(event: event, context: context)
    } catch {
      return .internalServerError
    }
  }

  private func handleInternal(event request: In, context _: Lambda.Context) async throws -> Out {
    switch (request.context.http.method, request.context.http.path) {
      case (.GET, "/hello"):
        return handleHello("world")
      case (.POST, "/hello"):
        guard let input = try? bodyDecoder.decode(Input.self, from: request.body ?? "") else {
          return .badRequest
        }
        return handleHello(input.name)
      default:
        return .notFound
    }
  }

  private func handleHello(_ name: String) -> Out {
    let output = try! bodyEncoder.encodeAsString(Output(hello: name))
    return Out(statusCode: .ok, body: output)
  }
}
