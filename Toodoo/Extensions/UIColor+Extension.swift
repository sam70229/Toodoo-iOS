//
//  UIColor+Extension.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
