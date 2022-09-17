import Combine
import Foundation

/// A helper class for network calls and error handling.
class NetworkRequestManager {
    //----------------------------------------
    // MARK: - API requests
    //----------------------------------------
    
    func apiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]? = nil,
        requestBody: Data? = nil
    ) -> AnyPublisher<Data, Error> {
        apiRequest(method, path, queryItems: queryItems, requestBody: requestBody, requiresAuthorization: false)
    }
    
    func authorizedApiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]? = nil,
        requestBody: Data? = nil
    ) -> AnyPublisher<Data, Error> {
        apiRequest(method, path, queryItems: queryItems, requestBody: requestBody, requiresAuthorization: true)
    }
    
    private func apiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]? = nil,
        requestBody: Data? = nil,
        requiresAuthorization: Bool
    ) -> AnyPublisher<Data, Error> {
        var apiURL: URL?
        guard var urlComponents = URLComponents(
            url: apiBaseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: AppError.urlError).eraseToAnyPublisher()
        }
        
        // Append query items.
        urlComponents.queryItems = queryItems
        
        if requiresAuthorization {
            // If query items are nil, initialize empty URLQueryItem array
            if urlComponents.queryItems == nil {
                urlComponents.queryItems = [URLQueryItem]()
            }
            
            // Set api-key as query item (Authentication)
            urlComponents.queryItems?.append(URLQueryItem(name: "api-key", value: apiKey))
        }
        
        apiURL = urlComponents.url
        
        guard let url = apiURL else {
            return Fail(error: AppError.urlError).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestBody
        
        return urlSession.dataTaskPublisher(for: request).tryMap { data, response in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  (200 ... 299).contains(httpURLResponse.statusCode)
            else {
                throw self.handleResponseFailure(data: data,
                                                 response: response)
            }
            return data
        }
        .mapError { error in
            return self.handleRequestFailure(error: error)
        }
        .eraseToAnyPublisher()
        
    }
    
    //----------------------------------------
    // MARK: - Error handling
    //----------------------------------------
    
    private func handleRequestFailure(error: Error) -> AppError {
        var wrappedError = AppError.badRequest
        if (error as NSError).domain == NSURLErrorDomain {
            wrappedError = AppError.network
        }
        
        return wrappedError
    }
    
    private func handleResponseFailure(data: Data?, response: URLResponse?) -> AppError {
        var error = AppError.badRequest
        
        if let response = (response as? HTTPURLResponse) {
            switch response.statusCode {
            case 401:
                error = AppError.authentication
                
            case 404:
                do {
                    let apiError = try JSONDecoder().decode(ApiError.self, from: data!)
                    switch apiError.code {
                    default:
                        error = .notFound
                    }
                } catch {
                    break
                }
                
            default:
                error = AppError.notFound
            }
        }
        
        return error
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    let apiBaseURL: URL = AppConstants.apiEndpoint
    
    let urlSession = URLSession.shared
    
    let apiKey: String = AppConstants.apiKey
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private var cancellable: Set<AnyCancellable> = Set()
}

