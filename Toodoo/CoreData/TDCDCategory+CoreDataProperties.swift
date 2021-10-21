//
//  TDCDCategory+CoreDataProperties.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData


extension TDCDCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDCDCategory> {
        return NSFetchRequest<TDCDCategory>(entityName: "TDCDCategory")
    }
    
    func makeCategroy() -> TDCategory {
        let category = TDCategory(from: self)
        
        return category
    }

}

extension TDCDCategory : Identifiable {

}
