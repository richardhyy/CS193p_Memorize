//
//  UIColor+RGBA.swift
//  Memorize
//
//  Created by Richard on 1/24/21.
//

import SwiftUI

extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}

extension UIColor {
    public struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
        
        init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
            self.red = red
            self.green = green
            self.blue = blue
            self.alpha = alpha
        }
        
        init?(fromString: String) {
            let split: [Substring] = fromString.split(separator: ",")
            if split.count >= 3 && split.count <= 4 {
                self.init(red: CGFloat(Float.parse(String(split[0]))/255), green: CGFloat(Float.parse(String(split[1]))/255), blue: CGFloat(Float.parse(String(split[2]))/255), alpha: split.count == 4 ? CGFloat(Float.parse(String(split[3]))/100) : 1.0)
            }
            else {
                return nil
            }
        }
    }
    
    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    public var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}
