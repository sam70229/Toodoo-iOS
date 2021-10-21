//
//  DetailsRouter.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import UIKit

class DetailsRouter: BaseRouter {
    
    private var todo: TDTodo
    private var storeManager: TDStoreManager
    
    init(todo: TDTodo, storeManager: TDStoreManager) {
        self.todo = todo
        self.storeManager = storeManager
    }
    
    override func makeViewController() -> UIViewController {
        let viewController = DetailsViewController(todo: self.todo, storeManager: self.storeManager)
        return viewController
    }
    
    func navigateToCategoryPickerController() {
        let viewController = CategoryPickerViewController()
        viewController.delegate = sourceView as! DetailsViewController
        sourceView!.navigationController?.pushViewController(viewController, animated: true)
    }

    func navigateToSubtaskPickerController() {
        let viewController = SubtaskPickerViewController()
//        viewController.delegate = sourceView as! DetailsViewController
//        viewController.todo = self.todo
        sourceView!.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismiss() {
        sourceView!.dismiss(animated: true, completion: nil)
    }
    
}
