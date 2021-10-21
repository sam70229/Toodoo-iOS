//
//  TDStore+Todos.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


extension TDStore {
    
    func fetchTodos(query: TDTodoQuery = TDTodoQuery(), callbackQueue: DispatchQueue = .main, completion: @escaping ResultClosure<[TDTodo]>) {
        switch self.storeType {
        case .remote:
            fetchValues(url: TodoApi.shared.queryTodos, offset: 0, limit: 0) { result in
                callbackQueue.async {
                    completion(result)
                }
            }
        case .local:
            let predicate = query.basicTodoPredicate()
            let sortDescriptor: [NSSortDescriptor] = query.sortDescriptors.map { order -> NSSortDescriptor in
                switch order {
                case .title(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCDTodo.title, ascending: ascending)
                case .createdDate(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCDTodo.createdDate, ascending: ascending)
                case .priority(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCDTodo.priority, ascending: ascending)
                case .remindTime(ascending: let ascending): return NSSortDescriptor(keyPath: \TDCDTodo.remind, ascending: ascending)
                }
            } + query.defaultSortDescriptors()
            
            fetchValues(predicate: predicate, sortDecriptors: sortDescriptor, offset: 0, limit: 10) { result in
                callbackQueue.async {
                    completion(result)
                }
            }
        }
    }
    
    func addTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue = .main, completion: ((Result<[TDTodo], TDStoreError>) -> Void)? = nil) {
        print(self.storeType)
        switch self.storeType {
        case .local:
            print("local add called")
            transaction(inserts: todos, updates: [], deletes: []) { result in
                callbackQueue.async {
                    completion?(result.map(\.inserts))
                }
            }
        case .remote:
            print("remote add called")
            
            remoteTransaction(url: TodoApi.shared.addTodoApi, httpMethod: .POST, payload: ["todos": todos]) { result in
                print(result)
//                callbackQueue.async {
//                    completion?(result)
//                }
            }
        }
    }
    
    func updateTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue, completion: ((Result<[TDTodo], TDStoreError>) -> Void)? = nil) {
        transaction(inserts: [], updates: todos, deletes: []) { result in
            callbackQueue.async {
                completion?(result.map(\.updates))
            }
        }
    }
    
    func deleteTodos(_ todos: [TDTodo], callbackQueue: DispatchQueue, completion: ((Result<[TDTodo], TDStoreError>) -> Void)? = nil) {
        print("Called delete Todos")
        switch self.storeType {
        case .local:
            transaction(inserts: [], updates: [], deletes: todos) { result in
                callbackQueue.async {
                    print(result)
                    completion?(result.map(\.deletes))
                }
            }
        case .remote:
            remoteTransaction(url: TodoApi.shared.addTodoApi, httpMethod: .POST, payload: ["todos": todos]) { result in
                print(result)
//                callbackQueue.async {
//                    completion?(result)
//                }
            }
        }
        
    }
}
