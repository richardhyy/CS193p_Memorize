//
//  Theme.swift
//  Memorize
//
//  Created by Richard on 1/19/21.
//

import Foundation
import SwiftUI

struct Theme<CardContent> {
    let name: String
    let color: Color
    let cardContents: [CardContent]
}
