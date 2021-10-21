//
//  TDCDCategory+CoreDataClass.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData

@objc(TDCDCategory)
public class TDCDCategory: CoreDataObject {

    @NSManaged var uid: UUID
    @NSManaged var title: String
    @NSManaged var createdDate: NSNumber
    
    
    convenience init(category: TDCategory, context: NSManagedObjectContext) {
        self.init(entity: Self.entity(), insertInto: context)
        self.uid = category.uid
        self.title = category.title
        self.createdDate = NSNumber(value: category.createdDate)
    }
    
    override func makeValue() -> TDCDCompatibleObject {
        makeCategroy()
    }
}
