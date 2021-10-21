//
//  TDListViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


class TDListViewController: UIViewController {
    
    var listView: TDListView {
        guard let view = self.view as? TDListView else { fatalError("Unsupported view type.") }
        return view
    }
    
    //MARK: - Life cycle
    
    override func loadView() {
        view = TDListView()
    }
    
    func appendViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.setupContainment(in: self, stackView: listView.stackView, animated: animated)
    }
    
    func appendView(_ view: UIView, animated: Bool) {
        listView.stackView.addArrangedSubview(view, animated: animated)
    }
    
    func insertViewController(_ viewController: UIViewController, at index: Int, animated: Bool) {
        viewController.setupContainment(in: self, stackView: listView.stackView, at: index, animated: animated)
    }
    
    func insertView(_view: UIView, at index: Int, animated: Bool) {
        listView.stackView.insertArrangedSubview(view, at: index, animated: animated)
    }
    
    func remove(at index: Int) {
        let view = listView.stackView.arrangedSubviews[index]
        if let viewController = children.first(where: { $0.view == view }) {
            viewController.clearContainment()
        } else {
            UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
                view.removeFromSuperview()
            }.startAnimation()
        }
    }
    
    func clear() {
        listView.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        children.forEach { $0.clearContainment() }
    }
}
