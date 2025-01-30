//
//  ImageRetriever.swift
//  NetworkImage Tests
//
//  Created by Joseph Wardell on 12/16/24.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import UniformTypeIdentifiers

public enum ImageRetriever: ImageDataRetriever {
    
    case shared
    
    public enum Error: Swift.Error {
        case NoMimeType(url: URL)
        case UnknownMimeType(url: URL)
        case NotAnImage(url: URL)
    }
    
    
    /// retieve an image from the URL passed in
    /// - Parameters:
    ///   - url: the url from which to retrieve the image
    ///   - headers: http headers that can be passed to the server (may be unused if the URL is not a http URL)
    ///   - configuration: `URLSessionConfiguration` that can be used in netwrok calls (may be unused if the URL is not a http URL)
    /// - Returns: `Data` that is expected to represent an image
    public func retrieveImageData(
        from url: URL,
        headers: [String: String]? = nil,
        configuration: URLSessionConfiguration = .default
    ) async throws -> Data {
        do {
            let (data, response) = try await HTTPRetriever.retrieve(url, headers: headers, configuration: configuration)
            guard let mimetype = response.mimeType else { throw Error.NoMimeType(url: url) }
            guard let type = UTType(mimeType: mimetype) else { throw Error.UnknownMimeType(url: url) }
            guard type.supertypes.contains(.image) else { throw Error.NotAnImage(url: url) }
            
            return data
        }
        catch HTTPRetriever.Error.NotAnHTTPURL {
            // NOTE: there's no guarantee here that the data passed back is in an image format
            // but that's okay since client code will do the necessary checks
            let data = try await FileURLRetriever.retrieve(url)
            return data
        }
    }
}

extension ImageRetriever.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        
        case .NoMimeType(let url):
            "The item retrieved from \(url) had no mime type"
        case .UnknownMimeType(let url):
            "The item retrieved from \(url) had an unknown mime type"
        case .NotAnImage(let url):
            "The item retrieved from \(url) is not an image"
        }
    }
}
