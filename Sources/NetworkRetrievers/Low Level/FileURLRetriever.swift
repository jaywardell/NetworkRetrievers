//
//  FileURLRetriever.swift
//  OCRAtorNetworking
//
//  Created by Joseph Wardell on 1/29/25.
//

import Foundation

public enum FileURLRetriever {
    
    public enum Error: Swift.Error {
        case NotAFIleURL(url: URL)
    }
    
    public static func retrieve(_ url: URL) async throws -> Data {
        guard ["file"].contains(url.scheme) else { throw Error.NotAFIleURL(url: url) }
        
        return try Data(contentsOf: url)
    }
}
