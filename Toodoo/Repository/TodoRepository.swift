//
//  TodoRepository.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import CoreData
import RxRelay


class TodoRepository {
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    let todos = BehaviorRelay<[TDTodo]>(value: [])
    
    init() {
        getTodos()
    }
    
    func getTodos() {
        let fetchRequest: NSFetchRequest<TDCDTodo> = TDCDTodo.fetchRequest()
        fetchRequest.predicate = .equal("recentlyDelete", value: false)
        let todos = try? context?.fetch(fetchRequest)
        let values = todos?.map({
            $0.makeTodo()
        })
        self.todos.accept(values!)
    }
    
    func updateTodo(todo: TDTodo) {
        
    }
    
    func deleteTodo(todo: TDCDTodo) {
        context?.delete(todo)
    }
}
