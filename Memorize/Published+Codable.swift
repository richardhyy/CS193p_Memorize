//
//  Published+Codable.swift
//  Memorize
//
//  Created by Alan Richard on 1/27/21.
//

import Foundation

extension Published: Codable where Value: Codable {
    public func encode(to encoder: Encoder) throws {
        guard
            let storageValue =
                Mirror(reflecting: self).descendant("storage")
                .map(Mirror.init)?.children.first?.value,
            let value =
                storageValue as? Value
                ??
                (storageValue as? Publisher).map(Mirror.init)?
                .descendant("subject", "currentValue")
                as? Value
        else { fatalError("Failed to encode") }
        
        try value.encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        self.init(initialValue: try .init(from: decoder))
    }
}
