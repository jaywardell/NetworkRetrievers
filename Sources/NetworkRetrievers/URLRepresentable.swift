//
//  URLRepresentable.swift
//  NetworkRetrievers
//
//  Created by Joseph Wardell on 3/6/25.
//

import Foundation

/// a type which can be represented as an URL
/// (including URL itself or URLComponents, or String, but really any type that can represent an URL)
/// All methods in this package take an `URLRepresntable` as their first parameter
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
