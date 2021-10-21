//
//  TDStore.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import UIKit
import CoreData
import RxSwift

typealias StoreProtocol = TDTodoStore & TDCategoryStore


class TDStore: StoreProtocol {
    
    let disposeBag = DisposeBag()
    
    private var connectionType: StoreSaveType!
    
    private let supportTypes: [TDCDCompatibleObject.Type] = [TDTodo.self, TDCategory.self]
    
    weak var todoDelegate: TDTodoStoreDelegate?
    
    weak var categoryDelegate: TDCategoryStoreDelegate?
    
    lazy var persistantContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    lazy var _context = persistantContainer.newBackgroundContext()
    
    var context: NSManagedObjectContext { return _context }
    
    let storeType: StoreSaveType
    
    public init(storeType type: StoreSaveType = .local) {
        self.storeType = type
        switch type {
        case .local:
            print("using core data")
            NotificationCenter.default.rx.notification(.NSManagedObjectContextDidSave, object: context).subscribe(onNext: { notification in
                self.contextDidSave(notification)
            }).disposed(by: disposeBag)
//            NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: .NSManagedObjectContextDidSave, object: context)
        case .remote:
            print("using remote database")
            NotificationCenter.default.rx.notification(.URLRequestDidSend, object: nil).subscribe(onNext: { notification in
                self.requestDidSend(notification)
            }).disposed(by: disposeBag)
        }
        
//        try! reset()
    }
    
    func reset() throws {
        for name in self.supportTypes.map({ $0.entity().name! }) {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: name)
            let objects = try self.context.fetch(fetchRequest)
            objects.forEach { self.context.delete($0) }
        }
        try self.context.save()
    }
    
//    @objc
    private func contextDidSave(_ notification: Notification) {
        
        guard let inserts = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> else { return }
        
        guard let updates = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> else { return }
        
        guard let deletes = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> else { return }
        
        print("inserts: \(inserts)")
        
        print("updates: \(updates)")
            
        print("deletes: \(deletes)")
        
        let todoInserts = inserts.compactMap { $0 as? TDCDTodo }
        
        let todoUpdates = updates.compactMap { $0 as? TDCDTodo }
        
        let todoDeletes = deletes.compactMap { $0 as? TDCDTodo }
        
        if !todoInserts.isEmpty {
            todoDelegate?.todoStore(self, didAddTodos: todoInserts.map { $0.makeTodo() })
        }
        
        if !todoUpdates.isEmpty {
            todoDelegate?.todoStore(self, didUpdateTodos: todoUpdates.map { $0.makeTodo() })
        }
        
        if !todoDeletes.isEmpty {
            todoDelegate?.todoStore(self, didDeleteTodos: todoDeletes.map { $0.makeTodo() })
        }
        
        let categoryInserts = inserts.compactMap { $0 as? TDCDCategory }
        
        let categoryUpdates = updates.compactMap { $0 as? TDCDCategory }
        
        let categoryDeletes = deletes.compactMap { $0 as? TDCDCategory }
        
        if !categoryInserts.isEmpty {
            categoryDelegate?.categoryStore(self, didAddCategories: categoryInserts.map { $0.makeCategroy() })
        }
        
        if !categoryUpdates.isEmpty {
            categoryDelegate?.categoryStore(self, didUpdateCategories: categoryUpdates.map { $0.makeCategroy() })
        }
        
        if !categoryDeletes.isEmpty {
            categoryDelegate?.categoryStore(self, didDeleteCategories: categoryDeletes.map { $0.makeCategroy() })
        }
    }
    
    private func requestDidSend(_ notification: Notification) {
        
        print("requestDidSend", notification.userInfo?[Notification.Name.SentPayload.rawValue])
        
//        print("inserts: \(inserts)")
//
//        print("updates: \(updates)")
//
//        print("deletes: \(deletes)")
//
//        let todoInserts = inserts.compactMap { $0 as? TDCDTodo }
//
//        let todoUpdates = updates.compactMap { $0 as? TDCDTodo }
//
//        let todoDeletes = deletes.compactMap { $0 as? TDCDTodo }
//
//        if !todoInserts.isEmpty {
//            todoDelegate?.todoStore(self, didAddTodos: todoInserts.map { $0.makeTodo() })
//        }
//
//        if !todoUpdates.isEmpty {
//            todoDelegate?.todoStore(self, didUpdateTodos: todoUpdates.map { $0.makeTodo() })
//        }
//
//        if !todoDeletes.isEmpty {
//            todoDelegate?.todoStore(self, didDeleteTodos: todoDeletes.map { $0.makeTodo() })
//        }
//
//        let categoryInserts = inserts.compactMap { $0 as? TDCDCategory }
//
//        let categoryUpdates = updates.compactMap { $0 as? TDCDCategory }
//
//        let categoryDeletes = deletes.compactMap { $0 as? TDCDCategory }
//
//        if !categoryInserts.isEmpty {
//            categoryDelegate?.categoryStore(self, didAddCategories: categoryInserts.map { $0.makeCategroy() })
//        }
//
//        if !categoryUpdates.isEmpty {
//            categoryDelegate?.categoryStore(self, didUpdateCategories: categoryUpdates.map { $0.makeCategroy() })
//        }
//
//        if !categoryDeletes.isEmpty {
//            categoryDelegate?.categoryStore(self, didDeleteCategories: categoryDeletes.map { $0.makeCategroy() })
//        }
    }
}
