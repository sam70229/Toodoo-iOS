//
//  BaseRouter.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


class BaseRouter {
    
    var viewController: UIViewController {
        makeViewController()
    }
    
    var sourceView: UIViewController?
    
    init() {}
    
    func makeViewController() -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
    
    func setSourceView(_ sourceView: UIViewController) {
        self.sourceView = sourceView
    }
}
