//
//  Data+StringEncoding.swift
//  SkyMark Data
//
//  Created by Joseph Wardell on 12/14/24.
//

import Foundation

@available(macOS 10.15, iOS 13, watchOS 6, tvOS 13, *)
extension Data {
    var stringEncoding: String.Encoding? {
#if os(Linux)
        return nil
#else
        var nsString: NSString?
        guard case let rawValue = NSString.stringEncoding(for: self, encodingOptions: nil, convertedString: &nsString, usedLossyConversion: nil), rawValue != 0 else { return nil }
        return String.Encoding(rawValue: rawValue)
#endif
    }
}
