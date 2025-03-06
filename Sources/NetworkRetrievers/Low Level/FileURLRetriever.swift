//
//  FileURLRetriever.swift
//  OCRAtorNetworking
//
//  Created by Joseph Wardell on 1/29/25.
//

import Foundation

public enum FileURLRetriever: Sendable {
    
    public enum Error: Swift.Error {
        case NotAnURL(URLRepresentable)
        case NotAFIleURL(URLRepresentable)
    }
    
    public static func retrieve(_ url: URLRepresentable) async throws -> Data {
        guard let url = url.representedURL else { throw Error.NotAnURL(url) }
        guard ["file"].contains(url.scheme) else { throw Error.NotAFIleURL(url) }
        
        return try Data(contentsOf: url)
    }
}
