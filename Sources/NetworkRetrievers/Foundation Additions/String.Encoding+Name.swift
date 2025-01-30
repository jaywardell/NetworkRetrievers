//
//  String.Encoding+Name.swift
//  SkyMark Data
//
//  Created by Joseph Wardell on 12/14/24.
//

import Foundation

extension String.Encoding {
    init?(name: String) {
        let cfe = CFStringConvertIANACharSetNameToEncoding(name as CFString)
        guard cfe != kCFStringEncodingInvalidId else { return nil }
        let se = CFStringConvertEncodingToNSStringEncoding(cfe)
        self.init(rawValue: se)
    }
    
    static func from(data: Data, textEncodingName: String? = nil, `default`: String.Encoding = .utf8) -> String.Encoding {
        if let textEncodingName,
           let fromName = String.Encoding(name: textEncodingName) {
            return fromName
        }
        return data.stringEncoding ?? `default`
    }
}
