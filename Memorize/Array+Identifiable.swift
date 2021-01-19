//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation

extension Array where Element: Identifiable {
    // Int?: Optional<Int>
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}
