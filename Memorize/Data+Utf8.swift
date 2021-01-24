//
//  Data+Utf8.swift
//  Memorize
//
//  Created by Richard on 1/24/21.
//

import Foundation

extension Data {
    // just a simple converter from a Data to a String
    var utf8: String? { String(data: self, encoding: .utf8 ) }
}
