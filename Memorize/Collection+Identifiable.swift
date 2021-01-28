//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation

extension Collection where Element: Identifiable {
    func firstIndex(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
    
    func firstIndex(ofId id: Element.ID) -> Self.Index? {
        firstIndex(where: { $0.id == id })
    }
    
    // note that contains(matching:) is different than contains()
    // this version uses the Identifiable-ness of its elements
    // to see whether a member of the Collection has **the same identity**
    func contains(matching element: Element) -> Bool {
        self.contains(where: { $0.id == element.id })
    }
}
