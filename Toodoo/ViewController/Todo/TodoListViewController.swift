//
//  TodoListViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import RxSwift


public enum TodoCategoryType {
    case all
    case single
    case recentlyDeleted
    
}


class TodoListViewController: TDListViewController {
    
    let categoryType: TodoCategoryType
    
    let category: TDCategory?
    
    let repo = TodoRepository()
    
    let storeManager: TDStoreManager!
    
    private let router: TodoListRouter
    
    private let disposeBag = DisposeBag()
    
    private var previousShowedHelpViewController: TodoViewController?
    
    init(query categoryType: TodoCategoryType = .all, category aCategory: TDCategory? = nil, storeManager: TDStoreManager) {
        self.categoryType = categoryType
        self.category = aCategory
        self.storeManager = storeManager
        self.router = TodoListRouter(storeManager: storeManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = setViewControllerBackgroundColor()
        title = self.category == nil ? "TodoList_nav_title".localized : self.category?.title
        navigationController?.navigationBar.prefersLargeTitles = true
        self.listView.stackView.spacing = 8
        
        self.router.setSourceView(self)
        
        setupAddBtn()
        
        subscribe()
        
        fetchTodos()
    }
    
    private func setupAddBtn() {
        let addBtn = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: nil)
        navigationItem.rightBarButtonItem = addBtn
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.router.navigateToDetailView()
        }).disposed(by: disposeBag)
    }
    
    private func subscribe() {
        storeManager.todosPublisher(categories: [.add, .update, .delete]).subscribe { _ in
            self.fetchTodos()
        }.disposed(by: disposeBag)
    }
    
    private func fetchTodos() {
        
        var query = TDTodoQuery(for: Date())
        
        switch categoryType {
        case .all:
            query.queryType = .all
        case .single:
            query.queryType = .single
            query.categoryName = self.category!.title
        case .recentlyDeleted:
            query.queryType = .recentlyDeleted
        }
        
//        storeManager.remoteStore.fetchTodos { [weak self] result in
//            guard let self = self else { print("not self"); return }
//            switch result {
//            case .failure(let error):
//                print(error.localizedDescription)
//            case .success(let todos):
//                self.clear()
//                for todo in todos {
//                    let viewController = TodoRouter(todo: todo, storeManager: self.storeManager).makeViewController() as! TodoViewController
////                    let viewController = TodoViewController(todo: todo, storeManager: self.storeManager)
//                    viewController.delegate = self
//                    self.appendViewController(viewController, animated: true)
//                }
//            }
//        }
        
        storeManager.store.fetchTodos(query: query, callbackQueue: .main) { [weak self] result in
            guard let self = self else { print("not self"); return }
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let todos):
                self.clear()
                for todo in todos {
                    let viewController = TodoRouter(todo: todo, storeManager: self.storeManager).makeViewController() as! TodoViewController
//                    let viewController = TodoViewController(todo: todo, storeManager: self.storeManager)
                    viewController.delegate = self
                    self.appendViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func updateShowedHelpViewController(_ viewController: TodoViewController) {
        if previousShowedHelpViewController != nil && previousShowedHelpViewController != viewController {
            previousShowedHelpViewController?.moveViewBackToCenter()
            //Update showed view controller
            previousShowedHelpViewController = viewController
        } else {
            previousShowedHelpViewController = viewController
        }
    }
    
    
    //MARK: - User Interface Style Change
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            self.view.backgroundColor = self.traitCollection.userInterfaceStyle == .dark ? .systemBackground : .secondarySystemBackground
        }
    }
}

extension TodoListViewController: TodoViewControllerDelegate {

    func didShowLeadingButton(_ viewController: TodoViewController, todo: TDTodo) {
//        let currentIndex = viewModel.todos.value.firstIndex(of: todo)!
        updateShowedHelpViewController(viewController)
    }
    
    func didShowTrailingButton(_ viewController: TodoViewController, todo: TDTodo) {
//        let currentIndex = viewModel.todos.value.firstIndex(of: todo)!
        updateShowedHelpViewController(viewController)
    }
    
}

