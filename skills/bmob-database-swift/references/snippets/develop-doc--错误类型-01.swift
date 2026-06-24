enum BmobError: Error {
    case notInitialized
    case invalidParameter(reason: String)
    case networkError(underlying: Error)
    case serverError(code: Int, message: String)
    case authenticationFailed
    case objectNotFound
    case timeout
    case jsonParsingFailed
}