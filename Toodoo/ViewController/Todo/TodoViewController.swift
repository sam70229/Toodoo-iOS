//
//  TodoViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import RxSwift


protocol TodoViewControllerDelegate: AnyObject {
    func didShowTrailingButton(_ viewController: TodoViewController, todo: TDTodo)
    func didShowLeadingButton(_ viewController: TodoViewController, todo: TDTodo)
}


class TodoViewController: UIViewController {
    
    var stackView: TDStackView {
        guard let view = self.view as? TDStackView else { fatalError("Unsupported view type.") }
        return view
    }
    
    var todoView: TodoView!
    
    private var todo: TDTodo
    private var viewModel: TodoViewModel
    private let disposeBag = DisposeBag()
    
    private let storeManager: TDStoreManager
    
    weak var delegate: TodoViewControllerDelegate!
    
    private let router: TodoRouter!
    private lazy var initialCenter = CGPoint()
    private lazy var animationDuration = 0.2
    
    init(todo: TDTodo, storeManager: TDStoreManager) {
        self.todo = todo
        self.storeManager = storeManager
        self.viewModel = TodoViewModel(todo: self.todo)
        self.todoView = TodoView(viewModel: self.viewModel)
        self.router = TodoRouter(todo: self.todo, storeManager: self.storeManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = TDStackView.vertical()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.stackView.addArrangedSubview(self.todoView)
        
        self.router.setSourceView(self)
        self.todoView.viewModel = self.viewModel
        
        subscribeTapActions()
        
        subscribeSwipeActions()
        
    }
    
    private func subscribeTapActions() {
        self.todoView.tapGesture.rx.event.bind { [weak self] tap in
            [self?.todoView.leadingView, self?.todoView.trailingView].forEach { $0?.isHidden = true; $0?.alpha = 0 }
            self?.router.navigateToDetailView()
        }.disposed(by: disposeBag)
        
        self.todoView.leadingView.button.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.navigateToDetailView()
            self?.moveViewBackToCenter()
        }).disposed(by: disposeBag)
        
        self.todoView.trailingView.button.rx.tap.subscribe(onNext: {
            self.storeManager.store.deleteTodo(self.todo)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeSwipeActions() {
        
        self.todoView.panGesture.delegate = self
        self.todoView.panGesture.rx.event.bind { [weak self] gesture in
            guard gesture.view != nil else { return }
            if let gestureView = gesture.view?.superview as? TodoView {
                let cardView = gestureView.cardBackground
            
                let translation = gesture.translation(in: gestureView)
                let screenCenter = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                
                if gesture.state == .began {
                    self?.initialCenter = cardView.center
                }
                
                if gesture.state != .cancelled {
                    if translation.x == 0 && translation.y != 0 {
                        gesture.state = .failed
                    }
                    cardView.center = CGPoint(x: self!.initialCenter.x + translation.x, y: self!.initialCenter.y)
                    gestureView.trailingView.isHidden = false
                    gestureView.leadingView.isHidden = false
                    
                    //MARK: - Trailing button
                    if translation.x < 0 && cardView.center.x < screenCenter.x && gestureView.trailingView.alpha != 1{
                        gestureView.trailingView.alpha = abs(translation.x) / 80
                    } else if translation.x > 0 && cardView.center.x < screenCenter.x && gestureView.trailingView.alpha > 0 {
                        gestureView.trailingView.alpha = 1 - (abs(translation.x) / 80)
                    }
                    //MARK: - Leading button
                    else if translation.x > 0 && cardView.center.x > screenCenter.x && gestureView.leadingView.alpha != 1 {
                        gestureView.leadingView.alpha = abs(translation.x) / 80
                    } else if translation.x < 0 && cardView.center.x > screenCenter.x && gestureView.leadingView.alpha > 0 {
                        gestureView.leadingView.alpha = 1 - (abs(translation.x) / 80)
                    }
                }
                
                if gesture.state == .ended {
                    //MARK: - Trailing button
                    if translation.x < -5 && cardView.center.x < screenCenter.x {
//                        print("x < 0, center < half screen")
                        UIViewPropertyAnimator(duration: self!.animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x / 2, y: self!.initialCenter.y)
                            gestureView.trailingView.isHidden = false
                            gestureView.trailingView.alpha = 1
                        }.startAnimation()
                        self!.delegate.didShowTrailingButton(self!, todo: self!.todo)
                    }
                    
                    else if translation.x > 5 && cardView.center.x < screenCenter.x {
//                        print("x > 0, center < half screen")
                        UIViewPropertyAnimator(duration: self!.animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x, y: self!.initialCenter.y)
                            gestureView.trailingView.isHidden = true
                            gestureView.trailingView.alpha = 0
                        }.startAnimation()
                    }
                    
                    //MARK: - Leading button
                    else if translation.x < -5 && cardView.center.x >= screenCenter.x {
//                        print("x < 0, center > half screen")
                        UIViewPropertyAnimator(duration: self!.animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x, y: self!.initialCenter.y)
                            gestureView.leadingView.isHidden = true
                            gestureView.leadingView.alpha = 0
                        }.startAnimation()
                    }
                    
                    else if translation.x > 5 && cardView.center.x > screenCenter.x {
//                        print("x > 0, center > half screen")
                        UIViewPropertyAnimator(duration: self!.animationDuration, curve: .easeOut) {
                            cardView.center = CGPoint(x: screenCenter.x + (screenCenter.x / 2), y: self!.initialCenter.y)
                            gestureView.leadingView.isHidden = false
                            gestureView.leadingView.alpha = 1
                        }.startAnimation()
                        self!.delegate.didShowLeadingButton(self!, todo: self!.todo)
                    }
                    
                }
            }
            
        }.disposed(by: disposeBag)
    }
    
    func moveViewBackToCenter() {
        UIViewPropertyAnimator(duration: animationDuration, curve: .easeOut) { [weak self] in
            self?.todoView.cardBackground.center = CGPoint(x: UIScreen.main.bounds.width / 2, y: self!.initialCenter.y)
            self?.hideHelperButton()
        }.startAnimation()
    }
    
    private func hideHelperButton() {
        [self.todoView.leadingView, self.todoView.trailingView].forEach { $0.isHidden = true; $0.alpha = 0 }
    }
    
    
    //MARK: - User Interface Changed
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            [self.todoView.cardBackground.contentView, self.todoView.shadowView.contentView, self.todoView.shadowView2.contentView].forEach {
                $0.layer.shadowColor = getShadowColor($0).cgColor
                $0.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
            }
            self.todoView.completedCheckBox.circleColor = UIColor.secondaryLabel
            self.todoView.completedCheckBox.strokeColor = UIColor.secondaryLabel
            self.todoView.ringIcon.image = self.traitCollection.userInterfaceStyle == .dark ?  UIImage(named: "bell-ring-outline") : UIImage(named: "bell-ring-outline-black")
            [self.todoView.leadingView, self.todoView.trailingView].forEach {
                $0.background.contentView.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? UIColor.secondarySystemBackground : UIColor.systemBackground
            }
            hideHelperButton()
            
        }
    }
}

extension TodoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.todoView.panGesture {
            return true
        }
        return false
    }
}
