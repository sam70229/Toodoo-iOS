//
//  Subtask.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import CoreData


struct TDSubtask: Codable {
    
    let uid: UUID
    var title: String
    var completed: Bool
    var createdDate: Double
    var completedDate: Double?
    
    init(title: String) {
        self.uid = UUID()
        self.title = title
        self.completed = false
        self.createdDate = Date().timeIntervalSince1970.rounded()
        self.completedDate = nil
    }
}

extension TDSubtask: TDCDCompatibleObject {
    
    static func entity() -> NSEntityDescription {
        TDSubtask.entity()
    }
    
    func insert(context: NSManagedObjectContext) -> CoreDataObject {
        TDCDSubtask(subtask: self, context: context)
    }
    
    func getUID() -> UUID {
        self.uid
    }
}

extension TDSubtask: TDCompatibleObject {
    
}
