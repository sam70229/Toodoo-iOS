//
//  TDStore+Categories.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


extension TDStore {
    
    func fetchCategories(query: TDCategoryQuery = TDCategoryQuery(), callbackQueue: DispatchQueue = .main,
                         completion: @escaping (Result<[TDCategory], TDStoreError>) -> Void) {
        let predicate = query.buildBasicPredicate()
        let sortDescriptor: [NSSortDescriptor] = query.sortDescriptors.map { order -> NSSortDescriptor in
            switch order {
            case .createdDate(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCategory.createdDate, ascending: ascending)
            case .title(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCategory.title, ascending: ascending)
            }
        } + query.defaultSortDescriptors()
        
        fetchValues(predicate: predicate, sortDecriptors: sortDescriptor, offset: 0, limit: 10) { result in
            callbackQueue.async {
                completion(result)
            }
        }
    }
    
    func addCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ((Result<[TDCategory], TDStoreError>) -> Void)? = nil) {
        transaction(inserts: categories, updates: [], deletes: []) { result in
            callbackQueue.async {
                completion?(result.map(\.inserts))
            }
        }
    }
    
    func updateCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ((Result<[TDCategory], TDStoreError>) -> Void)? = nil) {
        transaction(inserts: [], updates: categories, deletes: []) { result in
            callbackQueue.async {
                completion?(result.map(\.updates))
            }
        }
    }
    
    func deleteCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ((Result<[TDCategory], TDStoreError>) -> Void)? = nil) {
        transaction(inserts: [], updates: [], deletes: categories) { result in
            callbackQueue.async {
                completion?(result.map(\.deletes))
            }
        }
    }
    
}
