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
    
    enum Error: Swift.Error {
        case NoMimeType(url: URL)
        case UnknownMimeType(url: URL)
        case NotAnImage(url: URL)
    }
    
    public func retrieveImageData(from url: URL, headers: [String: String]?, configuration: URLSessionConfiguration) async throws -> Data {
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
    var errorDescription: String? {
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
