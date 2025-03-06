//
//  ImageDataRetriever+SwiftUI.swift
//  NetworkImage Tests
//
//  Created by Joseph Wardell on 12/17/24.
//

import SwiftUI


public extension ImageDataRetriever {
    func retrieveSwiftUI_Image(from url: URL, headers: [String: String]? = nil, configuration: URLSessionConfiguration = .default) async throws -> Image {
        
        let (retrieved, _) = try await retrieveImageData(from: url, headers: headers, configuration: configuration)
        
        let image = try ImageRetriever.shared.buildImage(from: retrieved)
        
        #if canImport(AppKit)
        return Image(nsImage: image)
        #else
        return Image(uiImage: image)
        #endif
    }
    
    func retrieveCGimage(from url: URL, headers: [String: String]? = nil, configuration: URLSessionConfiguration = .default) async throws -> CGImage {
        
        let (retrieved, _) = try await retrieveImageData(from: url, headers: headers, configuration: configuration)
        
        return try ImageRetriever.shared.buildCGImage(from: retrieved)
    }

}

extension ImageDataRetriever {
    
    public func fetchImage(at url: URL) async throws -> CGImage {
        try await retrieveCGimage(from: url)
    }
}
