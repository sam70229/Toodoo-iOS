//
//  StoreError.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


enum TDStoreError: LocalizedError {
    
    case fetchFailed(reason: String)
    
    case addFailed(reason: String)
    
    case updateFailed(reason: String)
        
    case deleteFailed(reason: String)
    
    case invalidValue(reason: String)
        
    case timeOut(reason: String)
        
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let reason): return "Failed to fetch: \(reason)"
        case .addFailed(let reason): return "Failed to add: \(reason)"
        case .updateFailed(let reason): return "Failed to update: \(reason)"
        case .deleteFailed(let reason): return "Failed to delete: \(reason)"
        case .invalidValue(let reason): return "invalid value: \(reason)"
        case .timeOut(let reason): return "Timed out: \(reason)"
        }
    }
    
}
