//
//  ImageDataRetriever.swift
//  SkyMark Data
//
//  Created by Joseph Wardell on 12/28/24.
//

import Foundation
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public protocol ImageDataRetriever {
    
    func retrieveImageData(
        from url: URL,
        headers: [String: String]?,
        configuration: URLSessionConfiguration
    ) async throws -> Data
}

extension ImageDataRetriever {
    func retrieveImageData(
        from url: URL,
        configuration: URLSessionConfiguration
    ) async throws -> Data {
        try await retrieveImageData(from: url, headers: nil, configuration: configuration)
    }
    
    func retrieveImageData(
        from url: URL,
        headers: [String: String]?
    ) async throws -> Data {
        try await retrieveImageData(from: url, headers: headers, configuration: .default)
    }
    
    func retrieveImageData(
        from url: URL
    ) async throws -> Data {
        try await retrieveImageData(from: url, headers: nil, configuration: .default)
    }
}

enum ImageDataRetrieverError: Swift.Error, LocalizedError {
    case Decoding
    
    var errorDescription: String? {
        switch self {
        case .Decoding:
            "Could not decode the data into an image"
        }
    }
}

extension ImageDataRetriever {
    

    public func buildCGImage(from data: Data) throws -> CGImage {
        
        let platformImage = try buildImage(from: data)
        
        #if canImport(UIKit)
        guard let out = platformImage.cgImage else { throw ImageDataRetrieverError.Decoding }
        #else
        guard let out = platformImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { throw ImageDataRetrieverError.Decoding }
        #endif
        return out
    }
    
#if canImport(AppKit)
    
    public func buildImage(from data: Data) throws -> NSImage {
        guard let imageRep = NSImage(data: data) else { throw ImageDataRetrieverError.Decoding }

        return imageRep
    }

    public func retrieveImage(from url: URL, headers: [String: String]? = nil, configuration: URLSessionConfiguration = .default) async throws -> NSImage {
        
        let data = try await retrieveImageData(from: url, headers: headers, configuration: configuration)

        return try buildImage(from: data)
    }
    
#elseif canImport(UIKit)
    
    public func buildImage(from data: Data) throws -> UIImage {
        guard let imageRep = UIImage(data: data) else { throw ImageDataRetrieverError.Decoding }

        return imageRep
    }
    
    public func retrieveImage(from url: URL, headers: [String: String]? = nil, configuration: URLSessionConfiguration = .default) async throws -> UIImage {
        
        let data = try await retrieveImageData(from: url, headers: headers, configuration: configuration)

        return try buildImage(from: data)
    }

#endif

}
