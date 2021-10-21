//
//  Utilities.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


func setCompletedText(string: String, completed: Bool) -> NSAttributedString {
    let attr_string = NSMutableAttributedString(string: string)
    let attr = [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue)]
    if completed {
        attr_string.addAttributes(attr, range: NSRange(location: 0, length: attr_string.length))
    } else {
        attr_string.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attr_string.length))
    }
    return attr_string
}

func dateFormat(_ format: String, from date: Date) -> String {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = format
    return dateformatter.string(from: date)
}

func dateFormat(_ format: String, from string: String) -> Date {
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = format
    return dateformatter.date(from: string)!
}

func transformDateFormatString(from format: String, to aFormat: String, dateString: String) -> String {
    let inputDateFormatter = DateFormatter()
    inputDateFormatter.dateFormat = format
    
    let date = inputDateFormatter.date(from: dateString)
    
    inputDateFormatter.dateFormat = aFormat
    return inputDateFormatter.string(from: date!)
}

func checkUsesAMPM() -> Bool {
    let locale = Locale.current
    let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: locale)
    return dateFormat?.range(of: "a") != nil ? true : false
}

func getPriority(from priority: NSDecimalNumber) -> String {
    let priorityMappingToString = [NSDecimalNumber(4): "Priority_None".localized, NSDecimalNumber(1): "Priority_High".localized, NSDecimalNumber(2): "Priority_Medium".localized, NSDecimalNumber(3): "Priority_Low".localized]
    return priorityMappingToString[priority]!
}

func getPriority(from priority: Int) -> String {
    let priorityMappingToString = [ 4: "Priority_None".localized, 1: "Priority_High".localized, 2: "Priority_Medium".localized, 3: "Priority_Low".localized]
    return priorityMappingToString[priority]!
}

func getPriority(from priority: String) -> NSDecimalNumber {
    let priorityMappingToDecimal = ["Priority_None".localized: Decimal(4), "Priority_High".localized: Decimal(1), "Priority_Medium".localized: Decimal(2), "Priority_Low".localized: Decimal(3)]
    return NSDecimalNumber(decimal: priorityMappingToDecimal[priority]!)
}

func getPriority(from priority: String) -> Int {
    let priorityMappingToDecimal = ["Priority_None".localized: 4, "Priority_High".localized: 1, "Priority_Medium".localized: 2, "Priority_Low".localized: 3]
    return priorityMappingToDecimal[priority]!
}

// MARK: User defaults

func setUserDefaults(key: String, value: Any) {
    UserDefaults.standard.set(value, forKey: key)
}

func getUserDefaults(key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}

// MARK: Views related

func getShadowColor(_ view: UIView) -> UIColor {
    return view.traitCollection.userInterfaceStyle == .dark ? .tertiarySystemBackground : .secondarySystemBackground
}

func setViewControllerBackgroundColor() -> UIColor {
    return UIViewController().traitCollection.userInterfaceStyle == .dark ? .systemBackground : .secondarySystemBackground
}

func chooseFirst<T>(then singularResultClosure: ResultClosure<T>?, replacementError: TDStoreError) -> ResultClosure<[T]> {
    return { arrayResult in
        switch arrayResult {
        case .failure(let error):
            singularResultClosure?(.failure(error))
        case .success(let array):
            if let first = array.first { singularResultClosure?(.success(first)); return }
            singularResultClosure?(.failure(replacementError))
        }
        
    }
}

func sendNotification(_ title: String, subtitle: String = "", body: String, badge: NSNumber = 1, sound: UNNotificationSound) {
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.badge = badge
    content.sound = sound
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}

func sendNotification(_ title: String, subtitle: String = "", body: String, badge: NSNumber = 1, date: Date, sound: UNNotificationSound) {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    
    var dateComponents = DateComponents()
    dateComponents.hour = calendar.component(.hour, from: date)
    dateComponents.minute = calendar.component(.minute, from: date) + 2
    print(dateComponents)
    
//        let triggerTime = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
    let content = UNMutableNotificationContent()
    content.title = title
    content.subtitle = subtitle
    content.body = body
    content.badge = badge
    content.sound = sound
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    print(trigger)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

}

func sendRemindNotification(_ todo: TDTodo, date: Date, sound: UNNotificationSound) {
    var calendar = Calendar.current
    calendar.timeZone = TimeZone.current
    
    var dateComponents = DateComponents()
    dateComponents.hour = calendar.component(.hour, from: date)
    dateComponents.minute = calendar.component(.minute, from: date)
    print(dateComponents)
    
    let content = UNMutableNotificationContent()
    content.title = todo.title
//        content.subtitle = subtitle
//        content.body = body
    content.badge = 1
    content.sound = sound
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
    print(trigger)
    
    let request = UNNotificationRequest(identifier: todo.uid.uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

}

func checkAndRemoveNotification(identifiers: [String]) {
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { notificationRequests in
            print(notificationRequests)
            var identifiersToDelete: [String] = []
            for notificationRequest in notificationRequests {
                print(notificationRequest.identifier)
                if identifiers.contains(notificationRequest.identifier) {
                    identifiersToDelete.append(notificationRequest.identifier)
                }
            }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersToDelete)
        }

    }
