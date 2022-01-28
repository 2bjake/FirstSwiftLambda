import AWSLambdaEvents

extension APIGateway.V2.Response {
  static var notFound: Self { .init(statusCode: .notFound) }
  static var badRequest: Self { .init(statusCode: .badRequest) }
  static var internalServerError: Self { .init(statusCode: .internalServerError) }
}
