//
//  TodoCategory.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import CoreData

struct TDCategory: TDCompatibleObject {
    
    let uid: UUID
    var title: String
    let createdDate: Double
    
    init(from cdCategory: TDCDCategory) {
        self.uid = cdCategory.uid
        self.title = cdCategory.title
        self.createdDate = cdCategory.createdDate.doubleValue
    }
    
    init(title: String) {
        self.uid = UUID()
        self.title = title
        self.createdDate = Date().timeIntervalSince1970.rounded()
    }
    
}

extension TDCategory: TDCDCompatibleObject {
    
    static func entity() -> NSEntityDescription {
        TDCDCategory.entity()
    }
    
    func insert(context: NSManagedObjectContext) -> CoreDataObject {
        TDCDCategory(category: self, context: context)
    }
    
    func getUID() -> UUID {
        self.uid
    }
}
