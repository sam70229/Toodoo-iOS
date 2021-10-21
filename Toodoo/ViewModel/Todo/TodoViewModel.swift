//
//  TodoViewModel.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


class TodoViewModel {
    var title: NSAttributedString?
    var completed: Bool
    var expiredDate: String?
    var remind: String?
    var remindText: String?
    var showRemindComponent: Bool
    var subtasks: [TDSubtask]
    var todo: TDTodo!
    var isExpanded = false
//    var subtasksCount: Int
    var completeSubtaskRateText: String?
    var completedSubtask: Int?
    
    private var view: TodoViewController?
    
    private var repository = TodoRepository()
    
    init(todo: TDTodo) {
        self.todo = todo
        self.title = setCompletedText(string: "\(todo.category) | \(todo.title)", completed: todo.completed)
        self.completed = todo.completed
        
        self.expiredDate = (todo.expiredDate != nil) ? "\(dateFormat("yyyy/MM/dd", from: Date(timeIntervalSince1970: todo.expiredDate!)))" : "TodoView_date_not_set".localized
        self.remind = todo.remind
        if todo.remind != nil {
            self.showRemindComponent = true
            self.remindText = checkUsesAMPM() ? transformDateFormatString(from: "HH:mm", to: "hh:mm a", dateString: self.remind!) : self.remind
        } else {
            self.showRemindComponent = false
        }
        self.subtasks = todo.subtasks ?? []
        self.completedSubtask = self.subtasks.reduce(0) { $1.completed == true ? $0 + 1 : $0 }
//        print(self.completedSubtask)
        self.completeSubtaskRateText = "\(self.completedSubtask!) / \(self.subtasks.count)"
    }
    
    func completeTodo(completion: (TodoViewModel) -> ()) {
        var newTodoViewModel = self
        newTodoViewModel.completed = !completed
        newTodoViewModel.title = setCompletedText(string: newTodoViewModel.title!.string, completed: newTodoViewModel.completed)
        self.repository.updateTodo(todo: newTodoViewModel.todo)
        completion(newTodoViewModel)
    }
    
    func expandTodo() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                self.view!.todoView.shadowView.alpha = 0
                self.view!.todoView.shadowView2.alpha = 0
                self.view!.todoView.shadowView.isHidden = true
                self.view!.todoView.shadowView2.isHidden = true
        }, completion: nil).startAnimation()
    }
    
    func collapseTodo() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view!.todoView.cardBackground.snp.updateConstraints { maker in
                if (self.subtasks.count >= 2) {
                    maker.bottom.equalToSuperview().inset(16)
                } else if (self.subtasks.count < 2) {
                    maker.bottom.equalToSuperview().inset(8)
                }
            }
            self.view!.todoView.shadowView.alpha = 1
            self.view!.todoView.shadowView2.alpha = 1
            self.view!.todoView.shadowView.isHidden = false
            self.view!.todoView.shadowView2.isHidden = false
        }, completion: nil).startAnimation()
    }
    
    func bind(view: TodoViewController?, router: TodoRouter) {
        self.view = view
    }
    
    func deleteTodo(todo: TDCDTodo) {
        repository.deleteTodo(todo: todo)
    }
    
    func moveToRecentlyDelete(todo: TDCDTodo) {
        todo.recentlyDelete = true
//        repository.updateTodo(todo: todo)
    }
    
    func updateTodo(todo: TDTodo) {
        var newTodoViewModel = self
        newTodoViewModel.todo = todo
//        view.completedCheckBox.isSelected = !view.completedCheckBox.isSelected
//        todo.completed = view.completedCheckBox.isSelected
//        view.title.attributedText = setCompletedText(string: view.title.attributedText!.string, completed: view.completedCheckBox.isSelected)
//        view.title.textColor = todo.completed ? .secondaryLabel : .label
//        view.datetime.textColor = todo.completed ? .secondaryLabel : .label
//        view.completeSubTaskLabel.textColor = todo.completed ? .secondaryLabel : .label
    }
}
