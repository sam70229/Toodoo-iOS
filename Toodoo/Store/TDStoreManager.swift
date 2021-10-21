//
//  StoreManager.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import RxSwift
import CoreData
import UIKit

enum StoreSaveType {
    case local
    case remote
}


class TDStoreManager: TDTodoStoreDelegate, TDCategoryStoreDelegate {
    
    static let shared = TDStoreManager()

    lazy var subject = PublishSubject<TDStoreNotification>()
    
    private (set) lazy var notificationPublisher = subject.share().asObservable()
    
    var store: StoreProtocol
    
//    let store = TDStore()
    
//    let remoteStore = TDRemoteStore()

    init(storeType: StoreSaveType = .local) {
        self.store = TDStore(storeType: storeType)
        self.store.todoDelegate = self
        self.store.categoryDelegate = self
    }
    
    // MARK: TDTodoStore Delegate
    
    func todoStore(_ store: TDTodoStore, didAddTodos todos: [TDTodo]) {
        dispatchTodoNotification(category: .add, todos: todos)
    }
    
    func todoStore(_ store: TDTodoStore, didUpdateTodos todos: [TDTodo]) {
        dispatchTodoNotification(category: .update, todos: todos)
    }
    
    func todoStore(_ store: TDTodoStore, didDeleteTodos todos: [TDTodo]) {
        dispatchTodoNotification(category: .delete, todos: todos)
    }
    
    private func dispatchTodoNotification(category: TDStoreNotificationCategory, todos: [TDTodo]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            todos.forEach {
                let notifications = TDTodoNotification(todo: $0, notificationCategory: category, storeManager: self)
                self.subject.onNext(notifications)
            }
        }
    }
    
    // MARK: TDCategoryStore Delegate

    func categoryStore(_ store: TDCategoryStore, didAddCategories categories: [TDCategory]) {
        dispatchCategoryNotification(category: .add, categories: categories)
    }
    
    func categoryStore(_ store: TDCategoryStore, didUpdateCategories categories: [TDCategory]) {
        dispatchCategoryNotification(category: .update, categories: categories)
    }
    
    func categoryStore(_ store: TDCategoryStore, didDeleteCategories categories: [TDCategory]) {
        dispatchCategoryNotification(category: .delete, categories: categories)
    }
    
    private func dispatchCategoryNotification(category: TDStoreNotificationCategory, categories: [TDCategory]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            categories.forEach {
                let notifications = TDCategoryNotification(category: $0, notificationCategory: category, storeManager: self)
                self.subject.onNext(notifications)
            }
        }
    }
    
}

extension TDStoreManager {
    
    // MARK: Todos
    
    func todosPublisher(categories: [TDStoreNotificationCategory]) -> Observable<TDTodo> {
        return notificationPublisher
            .compactMap { $0 as? TDTodoNotification }
            .filter { categories.contains($0.notificationCategory) }
            .map { $0.todo }
    }
    
    //MARK: Categories
    
    func categoriesPublisher(categories: [TDStoreNotificationCategory]) -> Observable<TDCategory> {
        return notificationPublisher
            .compactMap { $0 as? TDCategoryNotification }
            .filter { categories.contains($0.notificationCategory) }
            .map { $0.category }
    }
    
    
}
