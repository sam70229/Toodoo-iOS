//
//  TDRemoteStore.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/14.
//

import Foundation
import UIKit
import RxSwift

class RemoteConfig {
    
    let baseApi = URL(string: "http://192.168.50.108:8080")
//    let baseApi = URL(string: "http://localhost:8080")
    
    let version1 = "/api/v1/"
    
}

class TodoApi: RemoteConfig {
    
    static let shared = TodoApi()
    
    var addTodoApi: URL {
        return (baseApi?.appendingPathComponent(version1).appendingPathComponent("todo/add"))!
    }
    
    var queryTodos: URL {
        return (baseApi?.appendingPathComponent(version1).appendingPathComponent("todos"))!
    }
    
    func queryString(query dict: [String: Any]) -> URL {
        var url = baseApi?.appendingPathComponent(version1).appendingPathComponent("todo/")
        for (key, value) in dict {
            print("\(key) = \(value)")
            url = url?.appendingPathComponent("\(key)=\(value)")
        }
        
        return url!
    }
}

enum RemoteHttpMethod {
    case GET
    case POST
    
    var description: String {
        switch self {
        case .GET: return "GET"
        case .POST: return "POST"
        }
    }
}
