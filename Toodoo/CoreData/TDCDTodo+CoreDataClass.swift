//
//  TDCDTodo+CoreDataClass.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData

@objc(TDCDTodo)
public class TDCDTodo: CoreDataObject {
    
    @NSManaged var uid: UUID?
    @NSManaged var title: String
    @NSManaged var category: String
    @NSManaged var createdDate: NSNumber?
    @NSManaged var expiredDate: NSNumber?
    @NSManaged var priority: NSDecimalNumber?
    @NSManaged var remind: String?
    @NSManaged var desc: String?
    @NSManaged var subtasks: Set<TDCDSubtask>?
    @NSManaged var completed: Bool
    @NSManaged var recentlyDelete: Bool
    

    convenience init(todo: TDTodo, context: NSManagedObjectContext) {
        self.init(entity: Self.entity(), insertInto: context)
        self.uid = todo.uid
        self.title = todo.title
        self.category = todo.category
        self.completed = todo.completed
        self.createdDate = NSNumber(value: todo.createdDate)
        self.priority = NSDecimalNumber(value: todo.priority)
        self.recentlyDelete = false
    }

    override func makeValue() -> TDCDCompatibleObject {
        makeTodo()
    }
}
