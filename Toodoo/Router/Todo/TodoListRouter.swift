//
//  TodoListRouter.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/13.
//

import Foundation
import UIKit


class TodoListRouter: BaseRouter {
    
    let storeManager: TDStoreManager
    
    override func makeViewController() -> UIViewController {
        let viewController = TodoListViewController(query: .all, category: nil, storeManager: self.storeManager)
        return viewController
    }
    
    init(storeManager: TDStoreManager) {
        self.storeManager = storeManager
    }
    
    func navigateToDetailView() {
        let todo = TDTodo(title: "System_generate_new_todo_title".localized, category: getUserDefaults(key: "last_use_category") as! String)
        let detailsViewController = DetailsRouter(todo: todo, storeManager: storeManager).viewController
        let detail = UINavigationController(rootViewController: detailsViewController)
        sourceView!.present(detail, animated: true, completion: nil)
    }
    
}
