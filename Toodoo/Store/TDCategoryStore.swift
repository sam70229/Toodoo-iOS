//
//  CategoryStore.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import CoreData


protocol TDCategoryStore {
    
    var categoryDelegate: TDCategoryStoreDelegate? { get set }
    
    func fetchCategories(query: TDCategoryQuery, callbackQueue: DispatchQueue, completion: @escaping ResultClosure<[TDCategory]>)
    
    func fetchCategory(withID id: String, callbackQueue: DispatchQueue, completion: @escaping ResultClosure<TDCategory>)
    
    func addCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ResultClosure<[TDCategory]>?)
    
    func updateCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ResultClosure<[TDCategory]>?)
    
    func deleteCategories(_ categories: [TDCategory], callbackQueue: DispatchQueue, completion: ResultClosure<[TDCategory]>?)
    
    func addCategory(_ category: TDCategory, callbackQueue: DispatchQueue, completion: ResultClosure<TDCategory>?)
    
    func updateCategory(_ category: TDCategory, callbackQueue: DispatchQueue, completion: ResultClosure<TDCategory>?)
    
    func deleteCategory(_ category: TDCategory, callbackQueue: DispatchQueue, completion: ResultClosure<TDCategory>?)
    
}

extension TDCategoryStore {
    
    func fetchCategory(withID id: String, callbackQueue: DispatchQueue = .main, completion: @escaping ResultClosure<TDCategory>) {
        var query = TDCategoryQuery()
        query.limit = 1
        query.sortDescriptors = [.title(ascending: true)]
        fetchCategories(query: query, callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .fetchFailed(reason: "No category with matching ID")))
    }
    
    func addCategory(_ categories: TDCategory, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDCategory>? = nil) {
        addCategories([categories], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .addFailed(reason: "Failed to add category")))
    }
    
    func updateCategory(_ categories: TDCategory, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDCategory>? = nil) {
        updateCategories([categories], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .updateFailed(reason: "Failed to update category")))
    }
    
    func deleteCategory(_ categories: TDCategory, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDCategory>? = nil) {
        deleteCategories([categories], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .deleteFailed(reason: "Failed to delete category")))
    }
    
}

protocol TDCategoryStoreDelegate: AnyObject {
    
    func categoryStore(_ store: TDCategoryStore, didAddCategories categories: [TDCategory])
    
    func categoryStore(_ store: TDCategoryStore, didUpdateCategories categories: [TDCategory])
    
    func categoryStore(_ store: TDCategoryStore, didDeleteCategories categories: [TDCategory])
}
