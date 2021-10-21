//
//  TDCompatibleObject.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import CoreData

protocol TDCDCompatibleObject {
    
    static func entity() -> NSEntityDescription
    
    func insert(context: NSManagedObjectContext) -> CoreDataObject
    
    func getUID() -> UUID
}

protocol TDCompatibleObject: Codable {
    
}
