//
//  Array+Only.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
