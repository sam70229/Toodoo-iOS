//
//  TDCategoryQuery.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


struct TDCategoryQuery: Equatable, TDQueryProtocol {
    
    static func == (lhs: TDCategoryQuery, rhs: TDCategoryQuery) -> Bool {
        lhs.categoryIDs == rhs.categoryIDs
    }
    
    enum SortDescriptor: Equatable {
        case createdDate(ascending: Bool)
        case title(ascending: Bool)
    }
    
    var categoryIDs: [String] = []
    
    var sortDescriptors: [SortDescriptor] = []
    
    var limit: Int?
    
    var ids: [String] = []
    
    var uuids: [UUID] = []
    
    var dateInterval: DateInterval?
    
    var offset: Int = 0
    
    init() { }
    
    func buildBasicPredicate() -> NSPredicate {
        let predicate = NSPredicate(format: "title != nil")
        
        return predicate
    }
    
}
