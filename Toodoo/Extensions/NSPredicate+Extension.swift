//
//  NSPredicate+Extension.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation

/// credit from https://gist.github.com/grsouza/3c7e8796b42e0f4220e95c3aee6e426b
extension NSPredicate {
    static func equal(_ field: String, value: Any, caseInsensitive: Bool = false) -> NSPredicate {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        return NSPredicate(format: "%K ==\(caseInsensitiveModifier) %@", argumentArray: [field, value])
    }
    
    static func notEqual(_ field: String, value: Any, caseInsensitive: Bool = false) -> NSPredicate {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        return NSPredicate(format: "%K !=\(caseInsensitiveModifier) %@", argumentArray: [field, value])
    }
    
    static func any(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "ANY %K = %@", argumentArray: [field, value])
    }
    
    static func lessThan(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K < %@", argumentArray: [field, value])
    }
    
    static func lessThanOrEqual(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K <= %@", argumentArray: [field, value])
    }
    
    static func greaterThan(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K > %@", argumentArray: [field, value])
    }
    
    static func greaterThanOrEqual(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K >= %@", argumentArray: [field, value])
    }
    
    static func beginsWith(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K BEGINSWITH[c] %@", argumentArray: [field, value])
    }
    
    static func endsWith(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K ENDSWITH[c] %@", argumentArray: [field, value])
    }
    
    static func contains(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K CONTAINS[c] %@", argumentArray: [field, value])
    }
    
    static func like(_ field: String, value: Any) -> NSPredicate {
        return NSPredicate(format: "%K LIKE[c] %@", argumentArray: [field, value])
    }
    
    static func between(_ field: String, this: Any, and that: Any) -> NSPredicate {
        return NSPredicate(format: "%K BETWEEN {%@, %@}", argumentArray: [field, this, that])
    }
    
    static func `in`(_ field: String, values: [Any], caseInsensitive: Bool = false) -> NSPredicate {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        return NSPredicate(format: "%K IN\(caseInsensitiveModifier) %@", argumentArray: [field, values])
    }
    
    static func notIn(_ field: String, values: [Any], caseInsensitive: Bool = false) -> NSPredicate {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        return NSPredicate(format: "NOT (%K IN\(caseInsensitiveModifier) %@)", argumentArray: [field, values])
    }
    
    // MARK: - Compound Predicates
    
    static func and(_ predicates: NSPredicate...) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    static func or(_ predicates: NSPredicate...) -> NSPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
    }
    
    static func not(_ predicate: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(notPredicateWithSubpredicate: predicate)
    }
}
