//
//  DetailsViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import UIKit
import RxSwift


class DetailsViewController: UIViewController {
    
    let detailsView = DetailsView()
    
    private let todo: TDTodo
    
    private let storeManager: TDStoreManager
    
    private let viewModel: DetailsViewModel
    
    init(todo: TDTodo, storeManager: TDStoreManager) {
        self.todo = todo
        self.storeManager = storeManager
        self.router = DetailsRouter(todo: todo, storeManager: storeManager)
        self.viewModel = DetailsViewModel(todo: todo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = detailsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "NewTodoView_nav_cancel_title".localized, style: .plain, target: self, action: nil)
        
        self.detailsView.viewModel = self.viewModel
        self.router.setSourceView(self)
//        setupTodo()
        setupDetailsView()
        setupObservers()
        
        setupTapToDismissKeyboard()
        
        
        detailsView.titleTextfield.becomeFirstResponder()
        detailsView.detailDesc.delegate = self
//        viewModel.bind(view: self, router: router)
        
        let priorityMenu = UIMenu(title: "NewTodoView_priority_title".localized, options: .displayInline, children: [
            UIAction(title: "Priority_None".localized, handler: { ac in self.detailsView.priorityButton.setTitle(ac.title, for: .normal) }),
            UIAction(title: "Priority_Low".localized, handler: { ac in self.detailsView.priorityButton.setTitle(ac.title, for: .normal) }),
            UIAction(title: "Priority_Medium".localized, handler: { ac in self.detailsView.priorityButton.setTitle(ac.title, for: .normal) }),
            UIAction(title: "Priority_High".localized, handler: { ac in self.detailsView.priorityButton.setTitle(ac.title, for: .normal) })
        ])
        
        self.detailsView.priorityButton.menu = priorityMenu
                
        self.detailsView.categoryTap.rx.event.bind(onNext: { recognizer in
            self.router.navigateToCategoryPickerController()
        }).disposed(by: disposeBag)

        self.detailsView.subTaskTap.rx.event.bind(onNext: { recognizer in
            self.router.navigateToSubtaskPickerController()
        }).disposed(by: disposeBag)
        
        self.detailsView.dateTap.rx.event.bind(onNext: { recognzier in
            if !self.detailsView.datePicker.isDescendant(of: self.detailsView.dateContentStackView) {
                self.detailsView.dateContentStackView.addArrangedSubview(self.detailsView.datePicker, animated: true)
            }
            self.detailsView.datePicker.addAction( UIAction(handler: { action in
                self.detailsView.datePickerLabel.text = dateFormat("yyyy/MM/dd", from: self.detailsView.datePicker.date)
                self.detailsView.stackView.removeArrangedSubview(self.detailsView.datePicker, animated: true)
            }), for: .valueChanged)
        }).disposed(by: disposeBag)
        
        self.detailsView.datePickerSwitch.rx.isOn.subscribe(onNext: { isOn in
            if isOn {
                self.detailsView.datePickerLabel.isHidden = false
            } else {
                self.detailsView.datePickerLabel.isHidden = true
                self.detailsView.datePickerLabel.isHidden = true
                self.detailsView.stackView.removeArrangedSubview(self.detailsView.datePicker, animated: true)
            }
        }).disposed(by: disposeBag)
        
        self.detailsView.reminderTap.rx.event.bind(onNext: { recognzier in
            if !self.detailsView.reminderPicker.isDescendant(of: self.detailsView.reminderContentStackView) {
                self.detailsView.reminderContentStackView.addArrangedSubview(self.detailsView.reminderPicker, animated: true)
            }
            self.detailsView.reminderPicker.addAction( UIAction(handler: { action in
                self.detailsView.reminderPickerLabel.text = dateFormat("hh:mm a", from: self.detailsView.reminderPicker.date)
                self.detailsView.stackView.removeArrangedSubview(self.detailsView.reminderPicker, animated: true)
            }), for: .editingDidEnd)
        }).disposed(by: disposeBag)
        
        self.detailsView.reminderSwitch.rx.isOn.subscribe(onNext: { isOn in
            if isOn {
                self.detailsView.reminderPickerLabel.isHidden = false
            } else {
                self.detailsView.reminderPickerLabel.isHidden = true
                self.detailsView.reminderPicker.isHidden = true
                self.detailsView.stackView.removeArrangedSubview(self.detailsView.reminderPicker, animated: true)
            }
        }).disposed(by: disposeBag)
        
        self.navigationItem.rightBarButtonItem?.rx.tap.subscribe(onNext: { [weak self] in
            var newTodo = self!.todo
            newTodo.title = self!.detailsView.titleTextfield.text!
            newTodo.category = self!.detailsView.categoryPicker.text!
            newTodo.expiredDate = dateFormat("yyyy/MM/dd", from: (self!.detailsView.datePickerLabel.text)!).timeIntervalSince1970
            newTodo.priority = getPriority(from: self!.detailsView.priorityButton.title(for: .normal)!)
//            self.todo.priority = NSDecimalNumber(decimal: priorityMapping[self.detailsView.priorityButton.title(for: .normal)!]!)
            if self!.detailsView.reminderSwitch.isOn {
                newTodo.remind = checkUsesAMPM() ? transformDateFormatString(from: "hh:mm a", to: "HH:mm", dateString: self!.detailsView.reminderPickerLabel.text!)
                : self!.detailsView.reminderPickerLabel.text
//                print(Util.dateFormat("HH:mm", from: (self.todo?.remind)!))
                sendRemindNotification(newTodo, date: dateFormat("HH:mm", from: (newTodo.remind)!), sound: .default)
            } else {
                newTodo.remind = nil
                checkAndRemoveNotification(identifiers: [newTodo.uid.uuidString])

            }
            setUserDefaults(key: "last_use_category", value: (self!.detailsView.categoryPicker.text)!)
//            self.viewModel.updateTodo(todo: (self.todo)!)
            self!.storeManager.store.addTodos([newTodo], callbackQueue: .main, completion: nil)
            self!.router.dismiss()
        }).disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem?.rx.tap.subscribe(onNext: { [unowned self] in
            if self.isNewTodo {
//                self.viewModel.deleteTodo(todo: self.todo!)
            }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
    }
        
    private lazy var priorityMapping = ["Priority_None": Decimal(4), "Priority_High": Decimal(1), "Priority_Medium": Decimal(2), "Priority_Low": Decimal(3)]
    
//        weak var delegate: DetailsViewControllerDelegate!
    
    private var isNewTodo = false
    
    private let disposeBag = DisposeBag()
    
//    private var viewModel = DetailsViewModel()
//
    private var router: DetailsRouter!
    
    private var keyboardFrame: CGRect?
    
    private var activeTextView: UITextView? = nil
    
    private var previousTextViewRect: CGRect = .zero
        
    
    private func setupDetailsView() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NewTodoView_nav_update_title".localized, style: .plain, target: self, action: nil)
        
//        self.detailsView.categoryPicker.text = getUserDefaults(key: "last_use_category") as? String ?? "NewTodoView_category_not_set".localized

        self.navigationItem.title = "NewTodoView_nav_title".localized
    }
    
    private func setupTapToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func updateCategory(title: String) {
        DispatchQueue.main.async {
            self.detailsView.categoryPicker.text = title
        }
    }
    
    
    //MARK: - Handle Keyboard Appearence
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            guard beginFrame!.equalTo(endFrame!) == false else {
                return
            }
            self.keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect

            let keyboardIsShown = notification.name == UIResponder.keyboardWillShowNotification
            
            if let activeTextView = self.activeTextView {
                let textviewY = activeTextView.convert(activeTextView.bounds, to: self.view).maxY
            
                let topOfKeyboard = self.view.frame.height - self.keyboardFrame!.height
//                print(textviewY)
//                print(topOfKeyboard)
                
                if textviewY > topOfKeyboard {
                    self.view.frame.origin.y = keyboardIsShown ? -(textviewY - topOfKeyboard) : 0
                }
            }
        }
    }
    
    func updateSubTaskCount(count: String) {
        DispatchQueue.main.async {
            self.detailsView.subTaskCountLabel.text = count
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

/*
extension DetailsViewController: SubTaskPickerViewControllerDelegate {
    func updateSubTaskCount(count: Int) {
        self.updateSubTaskCount(count: "\(count)")
    }
}
*/

extension DetailsViewController: CategoryPickerViewControllerDelegate {
    func didFinishSelectCategory(_ viewController: UIViewController, category: TDCategory) {
//        self.updateCategory(title: category)
//        self.
        print("delegate from CategoryPickerViewControllerDelegate")
    }
}

extension DetailsViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing")
        self.activeTextView = textView
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "NewTodoView_detaildesc_placeholder".localized || textView.text == "NewTodoView_detaildesc_no_description".localized {
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.activeTextView = nil
        if textView.text == "" {
            textView.text = "NewTodoView_detaildesc_placeholder".localized
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.view.layoutIfNeeded()
//        self.scrollView.contentSize.height = textView.frame.minY + self.keyboardFrame!.height + 20
//
//        let pos = textView.endOfDocument
//        let currentRect = textView.caretRect(for: pos)
//        print(currentRect.origin.y, previousTextViewRect.origin.y)
//        if currentRect.origin.y > previousTextViewRect.origin.y {
//            print("expand", self.scrollView.contentOffset.y)
//            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y + 20)
//        } else if currentRect.origin.y < previousTextViewRect.origin.y {
//            print("collapse", self.scrollView.contentOffset.y)
//            self.scrollView.contentOffset = CGPoint(x: 0, y: self.scrollView.contentOffset.y - 20)
//        }
//        previousTextViewRect = currentRect
    }    
    
}
