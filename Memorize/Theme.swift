//
//  Theme.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation
import SwiftUI

struct Theme<CardContent: Codable>: Codable {
    let name: String
    let color: UIColor.RGB
    let amountOfPair: Int
    let cardContents: [CardContent]
}
