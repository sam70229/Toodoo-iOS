//
//  UIViewController+Extension.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


extension UIViewController {
    
    func clearContainment() {
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    func setupContainment(in containerViewController: UIViewController, stackView: TDStackView, animated: Bool = false) {
        containerViewController.addChild(self)
        stackView.addArrangedSubview(view, animated: animated)
        didMove(toParent: containerViewController)
    }
    
    func setupContainment(in containerViewController: UIViewController, stackView: TDStackView, at index: Int, animated: Bool = false) {
        containerViewController.addChild(self)
        stackView.insertArrangedSubview(view, at: index, animated: animated)
        didMove(toParent: containerViewController)
    }
}
 
