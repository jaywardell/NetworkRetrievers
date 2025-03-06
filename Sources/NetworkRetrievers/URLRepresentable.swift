//
//  URLRepresentable.swift
//  NetworkRetrievers
//
//  Created by Joseph Wardell on 3/6/25.
//

import Foundation

public protocol URLRepresentable: Sendable {
    var representedURL: URL? { get }
}

extension URL: URLRepresentable {
    public var representedURL: URL? { self }
}

extension URLComponents: URLRepresentable {
    public var representedURL: URL? { url }
}

extension String: URLRepresentable {
    public var representedURL: URL? { .init(string: self) }
}
