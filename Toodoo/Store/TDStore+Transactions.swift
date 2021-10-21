//
//  TDStore+Transactions.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation
import CoreData


extension TDStore {
    struct TransactionResult<T> {
        var inserts: [T] = []
        var updates: [T] = []
        var deletes: [T] = []
    }
    
    func fetchValues<T>(predicate: NSPredicate, sortDecriptors: [NSSortDescriptor], offset: Int, limit: Int?, completion: @escaping ResultClosure<[T]>)
    where T: TDCDCompatibleObject {
        print(predicate)
        print(sortDecriptors)
        context.perform {
            do {
                let request = NSFetchRequest<CoreDataObject>(entityName: T.entity().name!)
                request.predicate = predicate
                request.sortDescriptors = sortDecriptors
                request.fetchLimit = limit ?? 0
                request.fetchOffset = offset
                
                let fetched = try self.context.fetch(request)
                let values = fetched.map { $0.makeValue() as! T }
                completion(.success(values))
            } catch {
                completion(.failure(.fetchFailed(reason: error.localizedDescription)))
            }
        }
    }
    
    func transaction<T: TDCDCompatibleObject>(inserts: [T], updates: [T], deletes: [T], completion: @escaping ResultClosure<TransactionResult<T>>){
        context.perform {
            do {
                var result = TransactionResult<T>()
                if !inserts.isEmpty {
                    result.inserts = inserts.map { $0.insert(context: self.context) }.map { $0.makeValue() as! T }
                }
                
                if !updates.isEmpty {
                    result.updates = updates.map { $0.insert(context: self.context) }.map { $0.makeValue() as! T }
                }
                
                if !deletes.isEmpty {
                    _ = try deletes.map(self.deleteValue)
                }
                try self.context.save()
                completion(.success(result))
            } catch {
                self.context.rollback()
                completion(.failure(.invalidValue(reason: error.localizedDescription)))
            }
        }
    }
    
    func deleteValue(_ value: TDCDCompatibleObject) throws {
        let name = type(of: value).entity().name!

        let request = NSFetchRequest<CoreDataObject>(entityName: name)
        request.predicate = .equal("uid", value: value.getUID())
        
        let object = try? context.fetch(request)
        
        context.delete((object?.first)!)
    }
    
    func remoteTransaction<T: Encodable>(url: URL, httpMethod method: RemoteHttpMethod, payload: Dictionary<String, T>, completion: @escaping ResultClosure<Any>) {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.description
//        request.httpBody = try! JSONSerialization.data(withJSONObject: try! JSONEncoder().encode(payload), options: [])
        print(try! JSONEncoder().encode(payload))
        request.httpBody = try! JSONEncoder().encode(payload)
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: [])
            NotificationCenter.default.post(name: .URLRequestDidSend, object: nil, userInfo: [Notification.Name.SentPayload.rawValue: payload])
            completion(.success(jsonResponse))
        }, onError: { error in
            completion(.failure(.invalidValue(reason: error.localizedDescription)))
        }).disposed(by: disposeBag)
    }
    
    func fetchValues<T>(url: URL, offset: Int, limit: Int, completion: @escaping ResultClosure<[T]>) where T: TDCompatibleObject {
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            let todos = try? JSONDecoder().decode([String: [T]].self, from: data)

            completion(.success(todos?["Data"] ?? []))
        }, onError: { error in
            completion(.failure(.timeOut(reason: error.localizedDescription)))
        }).disposed(by: disposeBag)
    }
    

}
