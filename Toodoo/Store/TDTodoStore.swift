//
//  TDTodoStore.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import CoreData

typealias ResultClosure<T> = (Result<T, TDStoreError>) -> Void

protocol TDTodoStore {
    
    var todoDelegate: TDTodoStoreDelegate? { get set }
    
    func fetchTodos(query: TDTodoQuery, callbackQueue: DispatchQueue, completion: @escaping ResultClosure<[TDTodo]>)
    
    func fetchTodo(withID id: String, callbackQueue: DispatchQueue, completion: @escaping ResultClosure<TDTodo>)
    
    func addTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue, completion: ResultClosure<[TDTodo]>?)
    
    func updateTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue, completion: ResultClosure<[TDTodo]>?)
    
    func deleteTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue, completion: ResultClosure<[TDTodo]>?)
    
    func addTodo(_ todo: TDTodo, callbackQueue: DispatchQueue, completion: ResultClosure<TDTodo>?)
    
    func updateTodo(_ todo: TDTodo, callbackQueue: DispatchQueue, completion: ResultClosure<TDTodo>?)
    
    func deleteTodo(_ todo: TDTodo, callbackQueue: DispatchQueue, completion: ResultClosure<TDTodo>?)
    
}

extension TDTodoStore {
    
    func fetchTodo(withID id: String, callbackQueue: DispatchQueue = .main, completion: @escaping ResultClosure<TDTodo>) {
        var query = TDTodoQuery()
        query.sortDescriptors = [.title(ascending: true)]
        query.limit = 1
        fetchTodos(query: query, callbackQueue: .main, completion: chooseFirst(then: completion, replacementError: .fetchFailed(reason: "No todo with matching ID")))
        
    }
    
    func addTodo(_ todo: TDTodo, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDTodo>? = nil) {
        addTodos([todo], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .addFailed(reason: "Failed to add todo")))
    }
    
    func updateTodo(_ todo: TDTodo, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDTodo>? = nil) {
        updateTodos([todo], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .updateFailed(reason: "Failed to update todo")))
    }
    
    func deleteTodo(_ todo: TDTodo, callbackQueue: DispatchQueue = .main, completion: ResultClosure<TDTodo>? = nil) {
        deleteTodos([todo], callbackQueue: callbackQueue, completion: chooseFirst(then: completion, replacementError: .deleteFailed(reason: "Failed to delete todo")))
    }
    
}

protocol TDTodoStoreDelegate: AnyObject {
    
    func todoStore(_ store: TDTodoStore, didAddTodos todos: [TDTodo])
    
    func todoStore(_ store: TDTodoStore, didUpdateTodos todos: [TDTodo])
    
    func todoStore(_ store: TDTodoStore, didDeleteTodos todos: [TDTodo])
    
}
