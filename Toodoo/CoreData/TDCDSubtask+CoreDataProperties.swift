//
//  TDCDSubtask+CoreDataProperties.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData


extension TDCDSubtask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDCDSubtask> {
        return NSFetchRequest<TDCDSubtask>(entityName: "TDCDSubtask")
    }

    func makeSubtask() -> TDSubtask {
        let subtask = TDSubtask(title: title!)
        return subtask
    }
    
}

extension TDCDSubtask : Identifiable {

}
