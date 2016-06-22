/*
 This source file is part of the Swift.org open source project

 Copyright 2015 - 2016 Apple Inc. and the Swift project authors
 Licensed under Apache License v2.0 with Runtime Library Exception

 See http://swift.org/LICENSE.txt for license information
 See http://swift.org/CONTRIBUTORS.txt for Swift project authors
*/

import Utility
import struct PackageDescription.Version

public final class Package {
    public let url: String
    public let path: String
    public let name: String
    public var version: Version?
    public var dependencies: [Package] = []
    public let manifest: Manifest

    public init(manifest: Manifest, url: String) {
        self.manifest = manifest
        self.url = url
        self.path = manifest.path.parentDirectory
        self.name = manifest.package.name ?? Package.nameForURL(url)
    }

    public enum Error: ErrorProtocol {
        case noManifest(String)
        case noOrigin(String)
    }
}

extension Package: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension Package: Hashable, Equatable {
    public var hashValue: Int { return ObjectIdentifier(self).hashValue }
}

public func ==(lhs: Package, rhs: Package) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}

extension Package {
    public static func nameForURL(_ url: String) -> String {
        let base = url.basename

        switch URL.scheme(url) ?? "" {
        case "http", "https", "git", "ssh":
            if url.hasSuffix(".git") {
                let a = base.startIndex
                let b = base.index(base.endIndex, offsetBy: -4)
                return base[a..<b]
            } else {
                fallthrough
            }
        default:
            return base
        }
    }
}
