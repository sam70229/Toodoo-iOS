//
//  CategoryListViewControllre.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class CategoryListViewController: TDListViewController {
    
    private let disposeBag = DisposeBag()
    
    private let storeManager: TDStoreManager
    
    private var previousShowedHelpViewController: CategoryViewController?
    
    init(storeManager: TDStoreManager) {
        self.storeManager = storeManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "tab_bar_title_category".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        self.listView.stackView.spacing = 8
        
        setupAddBtn()
        
        storeManager.categoriesPublisher(categories: [.add, .update, .delete]).subscribe { _ in
            self.fetchCategories()
        }.disposed(by: disposeBag)
        
        fetchCategories()
        
    }
    
    private func setupAddBtn() {
        let addBtn = UIBarButtonItem(systemItem: .add, primaryAction: nil, menu: nil)
        navigationItem.rightBarButtonItem = addBtn
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.showAddCategoryAlert()
        }).disposed(by: disposeBag)
    }
    
    private func showAddCategoryAlert() {
        let alert = UIAlertController(title: "Category_alert_add_title".localized, message: "", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Category_alert_add_textfield_placeholder".localized
        }
        
        let cancel = UIAlertAction(title: "System_alert_cancel_btn".localized, style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let add = UIAlertAction(title: "System_alert_add_btn".localized, style: .default) { _ in
            print("Alert add tap")
            self.storeManager.store.addCategory(TDCategory(title: alert.textFields![0].text!))
        }
        alert.addAction(cancel)
        alert.addAction(add)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchCategories() {
        storeManager.store.fetchCategories(query: TDCategoryQuery(), callbackQueue: .main) { [weak self] result in
            print("Category Result: \(result)")
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let categories):
                self!.clear()
                for category in categories {
                    let viewController = CategoryViewController(category: category, storeManager: self!.storeManager)
                    viewController.delegate = self
                    self?.appendViewController(viewController, animated: true)
                }
            }
        }
    }
    
    private func updateShowedHelpViewController(_ viewController: CategoryViewController) {
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

extension CategoryListViewController: CategoryViewControllerDelegate {
    func didShowTrailingButton(_ viewController: CategoryViewController, category: TDCategory) {
        updateShowedHelpViewController(viewController)
    }

}
