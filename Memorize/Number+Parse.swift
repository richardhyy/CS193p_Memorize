//
//  Float+Parse.swift
//  Memorize
//
//  Created by Alan Richard on 1/27/21.
//

import Foundation

extension Float {
    static func parse(_ text: String) -> Float {
        return (text as NSString).floatValue
    }
}
