//
//  TDCDSubtask+CoreDataClass.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData

@objc(TDCDSubtask)
public class TDCDSubtask: CoreDataObject {
    
    @NSManaged var uid: UUID
    @NSManaged var title: String?
    @NSManaged var completed: Bool
    @NSManaged var todoUID: UUID?
    @NSManaged var todo: TDCDTodo?
    @NSManaged var createdDate: NSNumber

    convenience init(subtask: TDSubtask, context: NSManagedObjectContext) {
        self.init(entity: Self.entity(), insertInto: context)
        self.uid = subtask.uid
        self.title = subtask.title
        self.createdDate = NSNumber(value: subtask.createdDate)
    }
}
