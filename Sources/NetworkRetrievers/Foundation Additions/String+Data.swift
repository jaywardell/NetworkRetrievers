//
//  String+Data.swift
//  SkyMark Data
//
//  Created by Joseph Wardell on 12/14/24.
//

import Foundation

extension String {
    init?(data: Data, textEncodingName: String?, fallback: String.Encoding = .utf8) {
        let encoding = String.Encoding.from(data: data, textEncodingName: textEncodingName, default: fallback)
        self.init(data: data, encoding: encoding)
    }
}
