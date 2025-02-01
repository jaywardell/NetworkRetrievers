//
//  StringRetriever.swift
//  OpenGraph_Skeet_Retrieval_Tests
//
//  Created by Joseph Wardell on 12/14/24.
//

import Foundation

public enum StringRetriever: Sendable {
    
    public enum Error: Swift.Error, LocalizedError {
        case Decoding(url: URL)
        
        public var errorDescription: String? {
            switch self {
            case .Decoding(let url): "Could not create a string from the Data retrived from \(url)"
            }
        }
    }
    
    /// use URLSession to retrieve an html string from the given URL
    public static func retrieveString(
        from url: URL,
        headers: [String: String]? = nil,
        configuration: URLSessionConfiguration = .default
    ) async throws -> String {
        do {
            let (data, response) = try await HTTPRetriever.retrieve(url, headers: headers, configuration: configuration)
            guard let string = String(data: data, textEncodingName: response.textEncodingName, fallback: String.Encoding.utf8) else {
                throw Error.Decoding(url: url)
            }
            return string
        }
        catch HTTPRetriever.Error.NotAnHTTPURL {

            let data = try await FileURLRetriever.retrieve(url)
            
            for encoding in String.Encoding.prioritziedEncodings {
                guard let decoded = String(data: data, encoding: encoding) else { continue }
                return decoded
            }
            
            // no known encoding worked to create a String from the data
            // so for our purposes we will throw an error
            throw Error.Decoding(url: url)
        }
    }
}

fileprivate extension String.Encoding {
    
    /// the oncodings made available by Foundation as of macOS 10.10, iOS 8
    /// in roughly the order of their likelihood to be encountered in the wild
    /// starting with more standard formats
    /// and moving to more platfor-specific ones
    static var prioritziedEncodings: [String.Encoding] { [
        .utf8,
        .ascii,
        .unicode,
        .utf16,
        .utf32,
        .isoLatin1,
        .isoLatin2,
        .utf16BigEndian,
        .utf16LittleEndian,
        .utf32BigEndian,
        .utf32LittleEndian,
        .symbol,
        .nonLossyASCII,
        .japaneseEUC,
        .shiftJIS,
        .windowsCP1251,
        .windowsCP1252,
        .windowsCP1253,
        .windowsCP1254,
        .windowsCP1250,
        .iso2022JP,
        .macOSRoman,
        .nextstep,
    ] }
}
