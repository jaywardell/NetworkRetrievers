//
//  JSONRetriever.swift
//  NetworkRetrievers
//
//  Created by Joseph Wardell on 3/6/25.
//

import Foundation

public actor JSONRetriever {
    
    private let decoder = JSONDecoder()
    
    public static let shared = JSONRetriever()
    
    /// retieve a Decodable type from the URL passed in assuming that the data retrieved will be in JSON format
    /// - Parameters:
    ///   - url: the url from which to retrieve the image
    ///   - headers: http headers that can be passed to the server (may be unused if the URL is not a http URL)
    ///   - configuration: `URLSessionConfiguration` that can be used in netwrok calls (may be unused if the URL is not a http URL)
    /// - Returns: `Data` that is expected to represent an image
    public func retrieveJSON<D: Decodable>(
        from url: URL,
        headers: [String: String]? = nil,
        configuration: URLSessionConfiguration = .default
    ) async throws -> D {
        let (data, _) = try await HTTPRetriever.retrieve(url, headers: headers, configuration: configuration)

        let decoded = try decoder.decode(D.self, from: data)

        return decoded
    }

}
