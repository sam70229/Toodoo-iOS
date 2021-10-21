//
//  CategoryPickerViewController.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/13.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

protocol CategoryPickerViewControllerDelegate: AnyObject {
    func didFinishSelectCategory(_ viewController: UIViewController, category: TDCategory)
}


class CategoryPickerViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private let categories = BehaviorRelay<[TDCategory]>(value: [])
    
    weak var delegate: CategoryPickerViewControllerDelegate!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Category_nav_title".localized
        
        setupAddBtn()
        
        setupTableView()
        
        self.view.addSubview(tableView)
        
        TDStoreManager.shared.store.fetchCategories(query: TDCategoryQuery(), callbackQueue: .main) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let categories):
                self.categories.accept(categories)
            }
        }
        
        self.categories.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { row, data, cell in
            cell.textLabel!.text = data.title
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(TDCategory.self).subscribe(onNext: { [weak self] item in
            print("\(item) tapped")
            self!.delegate?.didFinishSelectCategory(self!, category: item)
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupAddBtn() {
        let add = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem = add
        
        add.rx.tap.subscribe(onNext: { [weak self] in
            //MARK: - Create alert
            let alert = UIAlertController(title: "Category_alert_add_title".localized, message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textfield in
                textfield.placeholder = "Category_alert_add_textfield_placeholder".localized
            })
            
            //MARK: - Add cancel btn in alert
            let cancel = UIAlertAction(title: "System_alert_cancel_btn".localized, style: .cancel, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancel)
            
            //MARK: - Add add btn in alert
            let addbtn = UIAlertAction(title: "System_alert_add_btn".localized, style: .default, handler: { [weak self] _ in
                setUserDefaults(key: "last_use_category", value: alert.textFields![0].text!)
                let category = TDCategory(title: alert.textFields![0].text!)
                TDStoreManager.shared.store.addCategory(category)
//                NotificationCenter.default.post(name: Notification.Name(rawValue: "Category Update"), object: self, userInfo: ["msg": "Update category"])
            })
            alert.addAction(addbtn)
            
            self?.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        self.tableView = UITableView(frame: .zero, style: .plain)
        self.tableView.separatorInset = .zero
        self.tableView.layoutMargins = .zero
        self.tableView.separatorColor = .black
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.bounces = true
        self.view.addSubview(self.tableView!)
        
        // TableView constraints
        self.tableView.snp.makeConstraints( {make in
            make.edges.equalToSuperview()
        })
    }
    
}
