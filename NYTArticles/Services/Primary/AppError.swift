import Foundation

/// Enum that captures all app and API errors regardless of the type.
public enum AppError: Error, Equatable {
    case dataSerialization(reason: String?)
    case invalidData
    case urlError
    case network

    // HTTP Status Code 400 range.
    case authentication
    case badRequest
    case notFound

    // HTTP Status code 500 range.
    case serverError
    
    //----------------------------------------
    // MARK: - API error
    //----------------------------------------
    
}

// This struct represents the API's error responses.
struct ApiError: Codable {
    let message: String
    let code: String
}
