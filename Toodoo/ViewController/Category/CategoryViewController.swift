//
//  CategoryViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import RxSwift

protocol CategoryViewControllerDelegate: AnyObject {
    func didShowTrailingButton(_ viewController: CategoryViewController, category: TDCategory)
}


class CategoryViewController: UIViewController {
    
    weak var delegate: CategoryViewControllerDelegate!
    
    private let category: TDCategory
    
    private let storeManager: TDStoreManager
    
    private lazy var initialCenter = CGPoint()
    
    private lazy var animationDuration = 0.2
    
    private let categoryView = CategoryView()
    
    private let disposeBag = DisposeBag()
    
    let viewModel: CategoryViewModel!
    
    override func loadView() {
        view = categoryView
    }
    
    init(category: TDCategory, storeManager: TDStoreManager) {
        self.category = category
        self.viewModel = CategoryViewModel(category: category)
        self.storeManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.categoryView.viewModel = self.viewModel
        
        subscribeTapActions()
        subscribeSwipeActions()
        
    }
    
    private func subscribeTapActions() {
        self.categoryView.tapGesture.rx.event.bind { [weak self] gesture in
            self!.enterCategoryDetail(category: self!.category.title)
            self!.moveViewBackToCenter()
        }.disposed(by: disposeBag)
        
        self.categoryView.trailingView.button.rx.tap.subscribe(onNext: {
            if self.category.title != "CategoryView_system_recently_deleted".localized {
                self.storeManager.store.deleteCategories([self.category], callbackQueue: .main, completion: nil)
            } else {
                self.enterCategoryDetail(category: self.category.title)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func subscribeSwipeActions() {
        self.categoryView.panGesture.delegate = self
        self.categoryView.panGesture.rx.event.bind { [unowned self] gesture in
            guard gesture.view != nil else { return }
            if let gestureView = gesture.view?.superview as? CategoryView {
                let cardView = gestureView.cardBackground
            
                let translation = gesture.translation(in: gestureView)
                let screenCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                
                if gesture.state == .began {
                    initialCenter = cardView.center
                    print("initialCenter: \(initialCenter)")
                }
                
                if gesture.state != .cancelled {
                    if initialCenter.x == screenCenter.x && translation.x > 0 {
                        /// prevent right swipe
                        gesture.state = .failed
                    } else if translation.x == 0 && translation.y != 0 {
                        /// prevent block scroll view swipe
                        gesture.state = .failed
                    } else {
                        cardView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y)
                        gestureView.trailingView.isHidden = false
                    }
                    
                    //MARK: - Trailing button
                    if translation.x < 0 && cardView.center.x < screenCenter.x && gestureView.trailingView.alpha != 1{
                        gestureView.trailingView.alpha = abs(translation.x) / 80
                    } else if translation.x > 0 && cardView.center.x < screenCenter.x && gestureView.trailingView.alpha > 0 {
                        gestureView.trailingView.alpha = 1 - (abs(translation.x) / 80)
                    }
                }
                
                if gesture.state == .ended {
                    //MARK: - Trailing button
                    if translation.x < -5 && cardView.center.x < screenCenter.x {
//                        print("x < 0, center < half screen")
                        UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x / 2, y: initialCenter.y)
                            gestureView.trailingView.isHidden = false
                            gestureView.trailingView.alpha = 1
                        }.startAnimation()
                        self.delegate.didShowTrailingButton(self, category: self.category)
                    }
                    
                    else if translation.x > 0 && cardView.center.x < screenCenter.x {
//                        print("x > 0, center < half screen")
                        UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x, y: initialCenter.y)
                            gestureView.trailingView.isHidden = true
                            gestureView.trailingView.alpha = 0
                        }.startAnimation()
                    } else if translation.x > 0 && cardView.center.x > screenCenter.x {
                        UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x, y: initialCenter.y)
                            gestureView.trailingView.isHidden = true
                            gestureView.trailingView.alpha = 0
                        }.startAnimation()
                    }
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func moveViewBackToCenter() {
        UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) {
            self.categoryView.cardBackground.center = CGPoint(x: lround(UIScreen.main.bounds.width / 2), y: lround(self.view.frame.maxY - self.view.frame.minY) / 2)
            self.categoryView.trailingView.isHidden = true
            self.categoryView.trailingView.alpha = 0
        }.startAnimation()
    }
    
    func enterCategoryDetail(category: String) {
        var viewController: TodoListViewController!
        if self.category.title != "CategoryView_system_recently_deleted".localized {
            viewController = TodoListViewController(query: .single, category: self.category, storeManager: self.storeManager)
        } else {
            viewController = TodoListViewController(query: .recentlyDeleted, category: self.category, storeManager: self.storeManager)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK: - User Interface Style Change
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            self.categoryView.cardBackground.contentView.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
        }
    }
    
}

extension CategoryViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.categoryView.panGesture {
            return true
        }
        return false
    }
}
