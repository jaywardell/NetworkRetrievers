//
//  StringRetriever.swift
//  OpenGraph_Skeet_Retrieval_Tests
//
//  Created by Joseph Wardell on 12/14/24.
//

import Foundation

public enum StringRetriever {
    
    public enum Error: Swift.Error, LocalizedError {
        case Decoding(url: URL)
        
        public var errorDescription: String? {
            switch self {
            case .Decoding(let url): "Could not load a String from the Data retrived from \(url)"
            }
        }
    }
    
    /// use URLSession to retrieve an html string from the given URL
    public static func retrieveString(
        from url: URL,
        headers: [String: String]? = nil,
        configuration: URLSessionConfiguration = .default
    ) async throws -> String {
        let (data, response) = try await HTTPRetriever.retrieve(url, headers: headers, configuration: configuration)
        guard let string = String(data: data, textEncodingName: response.textEncodingName, fallback: String.Encoding.utf8) else {
            throw Error.Decoding(url: url)
        }
        return string
    }
}
