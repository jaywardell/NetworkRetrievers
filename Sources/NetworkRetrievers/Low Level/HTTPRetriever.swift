//
//  HTTPRetriever.swift
//  SkyMark Data
//
//  Created by Joseph Wardell on 12/16/24.
//

import Foundation

public enum HTTPRetriever {
    
    public enum Error: Swift.Error {
        case NotAnHTTPURL(request: URLRequest)
        case NoData(request: URLRequest)
        case NoHTTPResponse(request: URLRequest)
        case HTTP(request: URLRequest, errorString: String?, statusCode: Int, httpHeaders: [String : String]? = nil) // contains an http error code (e.g. 404)
    }
    
    /// Our canonical approach to using URLSession to retrieve an URL via http
    ///
    /// Send all URLRequests through here
    public static func retrieve(_ request: URLRequest, configuration: URLSessionConfiguration = .default) async throws-> (Data, HTTPURLResponse) {
        guard let url = request.url, ["http", "https"].contains(url.scheme) else { throw Error.NotAnHTTPURL(request: request) }
        
        let session = URLSession(configuration: configuration)
        let (data, response) = try await session.data(for: request)
        guard !data.isEmpty else { throw Error.NoData(request: request) }
        guard let response = response as? HTTPURLResponse else { throw Error.NoHTTPResponse(request: request) }
        guard (200..<300).contains(response.statusCode) else {
            let errorResponse = String(data: data, encoding: .utf8) ?? "No response body"
            let httpHeaders = response.allHeaderFields as? [String: String] ?? [:]
            throw Error.HTTP(request: request, errorString: errorResponse, statusCode: response.statusCode, httpHeaders: httpHeaders)
        }
        return (data, response)
    }

    /// syntactical sugar for the retrieve method that takes an URL
    public static func retrieve(_ url: URL, headers: [String: String]? = nil, configuration: URLSessionConfiguration = .default) async throws-> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        headers?.compactMapValues { $0 }.forEach {
            request.setValue($1, forHTTPHeaderField: $0)
        }
        return try await retrieve(request, configuration: configuration)
    }
}

extension HTTPRetriever.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
            
        case .NotAnHTTPURL(let request):
            "URL is not an HTTP URL: \(request.url?.absoluteString ?? "no URL")"
        case .NoData(let request):
            "Received no data from request \(request)"
        case .NoHTTPResponse(let request):
            "Received no HTTPURLResponse from request \(request)"
        case .HTTP(request: let request, errorString: let responseString, statusCode: let statusCode, httpHeaders: _):
            "HTTP Error Status Code: \(statusCode) for request \(request): \(responseString ?? "")"
        }
    }
}
