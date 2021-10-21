//
//  TDQueryProtocol.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


protocol TDQueryProtocol {
    
    var ids: [String] { get }
    
    var uuids: [UUID] { get }
    
    var dateInterval: DateInterval? { get }
    
    var limit: Int? { get }
    
    var offset: Int { get }
}

extension TDQueryProtocol {
    
    func defaultSortDescriptors() -> [NSSortDescriptor] {
        [NSSortDescriptor(key: "createdDate", ascending: false)]
    }
    
    func basicPredicate() -> NSPredicate {
        var predicate = NSPredicate(format: "createdDate != nil")
        
        if let interval = dateInterval {
            let endPredicate = NSPredicate.lessThanOrEqual("createdDate", value: interval.end)
            let startPredicate = NSPredicate.greaterThanOrEqual("createdDate", value: interval.start)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, startPredicate, endPredicate])
        }
        return predicate
    }
}
