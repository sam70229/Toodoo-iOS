//
//  Todo.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import CoreData


struct TDTodo {
    
    let uid: UUID
    var title: String
    var category: String
    var createdDate: Double
    var expiredDate: Double?
    var priority: Int
    var remind: String?
    var desc: String?
    var subtasks: [TDSubtask]?
    var completed: Bool
    var recentlyDelete: Bool
    
    init(title: String, category: String) {
        self.uid = UUID()
        self.title = title
        self.category = category
        self.createdDate = Date().timeIntervalSince1970.rounded()
        self.expiredDate = nil
        self.priority = 4
        self.remind = nil
        self.desc = nil
        self.subtasks = []
        self.completed = false
        self.recentlyDelete = false
    }
    
    init(todo: TDCDTodo) {
        self.uid = todo.uid!
        self.title = todo.title
        self.category = todo.category
        self.createdDate = todo.createdDate!.doubleValue
        self.expiredDate = todo.expiredDate?.doubleValue
        self.priority = todo.priority!.intValue
        self.remind = todo.remind
        self.desc = todo.desc
        self.subtasks = todo.subtasks?.map({ $0.makeSubtask() })
        self.completed = todo.completed
        self.recentlyDelete = todo.recentlyDelete
    }
    
}

extension TDTodo: TDCDCompatibleObject {
    
    static func entity() -> NSEntityDescription {
        TDCDTodo.entity()
    }
    
    func insert(context: NSManagedObjectContext) -> CoreDataObject {
        TDCDTodo(todo: self, context: context)
    }
    
    func getUID() -> UUID {
        self.uid
    }
    
}

extension TDTodo: TDCompatibleObject {
    
}
