//
//  TodoRouter.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


class TodoRouter: BaseRouter {
    
    private let todo: TDTodo
    private let storeManager: TDStoreManager
    
    init(todo: TDTodo, storeManager: TDStoreManager) {
        self.todo = todo
        self.storeManager = storeManager
    }
    
    override func makeViewController() -> UIViewController {
        let viewController = TodoViewController(todo: self.todo, storeManager: self.storeManager)
        return viewController
    }
    
    func navigateToDetailView() {
        let detailsViewController = DetailsViewController(todo: self.todo, storeManager: self.storeManager)
        let details = UINavigationController(rootViewController: detailsViewController)
        self.sourceView?.present(details, animated: true, completion: nil)
    }
    
}
