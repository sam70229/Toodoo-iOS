//
//  String+Extension.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation

protocol Localizable {
    var localizedKey: String? { get set }
}

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
