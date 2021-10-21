//
//  TDCDTodo+CoreDataProperties.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//
//

import Foundation
import CoreData


extension TDCDTodo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TDCDTodo> {
        return NSFetchRequest<TDCDTodo>(entityName: "TDCDTodo")
    }
    
    func makeTodo() -> TDTodo {
        let todo = TDTodo(todo: self)
        
        return todo
    }

}

extension TDCDTodo : Identifiable {

}
