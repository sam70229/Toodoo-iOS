//
//  TDStackView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


enum Animation {
    case fade, hidden
}


class TDStackView: UIStackView {
    
    private let duration = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func vertical() -> TDStackView {
        let stackView = TDStackView()
        stackView.axis = .vertical
        return stackView
    }
    
    static func horizontal() -> TDStackView {
        let stackView = TDStackView()
        stackView.axis = .horizontal
        return stackView
    }
    
    func addArrangedSubview(_ view: UIView, animated: Bool) {
        guard animated else {
            addArrangedSubview(view)
            return
        }
        view.isHidden = true
        super.addArrangedSubview(view)
        toggleViews([view], shouldShow: true, animated: animated)
        
    }
    
    func insertArrangedSubview(_ view: UIView, at stackIndex: Int, animated: Bool) {
        guard animated else {
            insertSubview(view, at: stackIndex)
            return
        }
        view.isHidden = true
        super.insertSubview(view, at: stackIndex)
        toggleViews([view], shouldShow: true, animated: animated)
    }
    
    func removeArrangedSubview(_ view: UIView, animated: Bool) {
        
        let removeBlock = {
            view.removeFromSuperview()
            view.isHidden = false
            view.alpha = 1
        }
        
        guard UIView.areAnimationsEnabled && animated else {
            removeBlock()
            return
        }
        
        toggleViews([view], shouldShow: false, animated: animated) { complete in
            guard complete else { return }
            removeBlock()
        }
    }
    
    func clear(animated: Bool = false) {
        let removeViewsBlock = { [weak self] in
            self?.subviews.forEach { $0.removeFromSuperview() }
        }
        
        guard UIView.areAnimationsEnabled && animated else {
            removeViewsBlock()
            return
        }
        
        toggleViews(subviews, shouldShow: false, animated: true) { complete in
            guard complete else { return }
            removeViewsBlock()
        }
    }
    
    func toggleViews(_ views: [UIView], shouldShow: Bool, animated: Bool, animations: [Animation] = [.fade, .hidden], completion: ((Bool) -> Void)? = nil) {
        views.forEach { guard $0.superview == self else { return } }
        
        guard animated else {
            views.forEach { $0.isHidden = !shouldShow }
            return
        }
        
        var completionWillBeCalled = false
        
        if animations.contains(.hidden) {
            let filteredViews = views.filter { $0.isHidden == shouldShow }
            filteredViews.forEach { $0.isHidden = shouldShow }
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                filteredViews.forEach { $0.isHidden = !shouldShow }
            }, completion: { complete in
                if !completionWillBeCalled { completion?(complete) }
                completionWillBeCalled = true
            })
        }
        
        if animations.contains(.fade) {
            let filteredViews = views.filter { $0.alpha == (shouldShow ? 0 : 1) }
            filteredViews.forEach { $0.alpha = (shouldShow ? 0 : 1) }
            
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                filteredViews.forEach { $0.alpha = (shouldShow ? 0 : 1) }
            }, completion: { complete in
                if !completionWillBeCalled { completion?(complete) }
                completionWillBeCalled = true
            })
        }
    }
}
