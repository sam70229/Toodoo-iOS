//
//  TDStoreNotification.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/12.
//

import Foundation


protocol TDStoreNotification {}

enum TDStoreNotificationCategory {
    case add
    case update
    case delete
}

struct TDTodoNotification: TDStoreNotification {
    let todo: TDTodo
    let notificationCategory: TDStoreNotificationCategory
    let storeManager: TDStoreManager
}

struct TDCategoryNotification: TDStoreNotification {
    let category: TDCategory
    let notificationCategory: TDStoreNotificationCategory
    let storeManager: TDStoreManager
}
