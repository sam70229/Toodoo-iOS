//
//  DetailsViewModel.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/13.
//

import Foundation
import UIKit


class DetailsViewModel {
    
    var title: String
    
    var category: String
    
    var subtaskCount: Int
    
    var expiredDate: Date?
    var expiredDateText: String?
    
    var remindTimeText: String?
    
    var priorityText: String
    
    var detailDescription: String?
    
    var navigationRightItem: UIBarButtonItem?
    
    init(todo: TDTodo) {
        
        self.title = todo.title
        
        self.category = todo.category
        
        self.subtaskCount = todo.subtasks?.count ?? 0
        
        self.expiredDate = todo.expiredDate != nil ? Date(timeIntervalSince1970: todo.expiredDate!) : nil
        self.expiredDateText = todo.expiredDate != nil ? dateFormat("yyyy/MM/dd", from: self.expiredDate!) : nil
        
        self.remindTimeText = todo.remind != nil ? (checkUsesAMPM() ? transformDateFormatString(from: "HH:mm", to: "hh:mm a", dateString: todo.remind!) : todo.remind) : nil
        
        self.priorityText = getPriority(from: todo.priority)
        
        self.detailDescription = todo.desc
        
        self.navigationRightItem = UIBarButtonItem(title: "NewTodoView_nav_update_title".localized, style: .plain, target: self, action: nil)
        
        /*
        titleTextfield.text = todo.title
        categoryPicker.text = todo.category ?? getUserDefaults(key: "last_use_category") != nil ? getUserDefaults(key: "last_use_category") as! String : "NewTodoView_category_not_set".localized
        subTaskCountLabel.text = "\(todo.subtasks?.count ?? 0)"
        datePickerLabel.text = dateFormat("yyyy/MM/dd", from: todo.expiredDate ?? Date())
        datePicker.setDate(todo.expiredDate ?? Date(), animated: true)
        if todo.remind != nil {
            reminderSwitch.setOn(true, animated: true)
            reminderPickerLabel.text = checkUsesAMPM() ? transformDateFormatString(from: "HH:mm", to: "hh:mm a", dateString: todo.remind!) : todo.remind
        }
        priorityButton.setTitle(getPriority(from: todo.priority), for: .normal)
        detailDesc.text = todo.desc ?? ("NewTodoView_detaildesc_no_description".localized)
        navigationItem.rightBarButtonItem?.title = "NewTodoView_nav_update_title".localized
        */
    }
    
    
}
