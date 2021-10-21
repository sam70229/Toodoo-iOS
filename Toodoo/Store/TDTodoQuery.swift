//
//  TDTodoQuery.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


struct TDTodoQuery: Equatable, TDQueryProtocol {
    
    var sortDescriptors: [SortDescriptor] = []
    
    enum SortDescriptor: Equatable {
        case title(ascending: Bool)
        case createdDate(ascending: Bool)
        case priority(ascending: Bool)
        case remindTime(ascending: Bool)
    }
    
    var ids: [String] = []
    
    var uuids: [UUID] = []
    
    var dateInterval: DateInterval?
    
    var limit: Int?
    
    var offset: Int = 0
    
    var queryType: TodoCategoryType = .all
    
    var categoryName: String = ""
    
    static func == (lhs: TDTodoQuery, rhs: TDTodoQuery) -> Bool {
        lhs.uuids == rhs.uuids
    }
    
    init() {}
    
    init(dateInterval: DateInterval? = nil) {
        self.dateInterval = dateInterval
    }
    
    init(for date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)!
        self = Self(dateInterval: DateInterval(start: startOfDay, end: endOfDay))
    }
    
    init(id: String) {
        self.ids = [id]
    }
    
    func basicTodoPredicate() -> NSPredicate {
        var predicate = NSPredicate(format: "createdDate != nil")
        switch self.queryType {
        case.all:
            let notDeletedPredicate = NSPredicate.equal("recentlyDelete", value: false)
//            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, notDeletedPredicate])
            if let interval = dateInterval {
                let endPredicate = NSPredicate.lessThanOrEqual("createdDate", value: interval.end.timeIntervalSince1970)
                let startPredicate = NSPredicate.greaterThanOrEqual("createdDate", value: interval.start.timeIntervalSince1970)
                predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, startPredicate, endPredicate, notDeletedPredicate])
            }
        case .single:
            let specificPredicate = NSPredicate.equal("category", value: self.categoryName)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, specificPredicate])
        case .recentlyDeleted:
            let recentlyDeletedPredicate = NSPredicate.equal("recentlyDelete", value: true)
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, recentlyDeletedPredicate])
        }
        return predicate
    }
}
