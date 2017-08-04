//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Jonathan Go on 2017/08/04.
//  Copyright © 2017 Appdelight. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //creates navigation buttons
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //request for an alert, a message to show, a badge and sound.  Also need a closure when the user approves or denied the request.
    func registerLocal() {
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(granted, error) in
            
            if granted {
                
                print ("Yay!")
            } else {
                
                print("D'oh")
            }
        })
    
    }
    
    /* Data needed to schedule a notification
    1. content (what to show)
    2. trigger (when to show it)
    3. request (the combination of content and trigger)
    */
    func scheduleLocal() {
        
        registerLocal()
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()   //what to show
        
        content.title = "Late wake up call"
        content.body = "the early bird catches the worm, but the second mouse catches the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default()
        
        //trigger
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        
        //test notifications with this interval trigger - can set with a low number for testing
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
       
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        //uuid to generate unique identifier
        
        center.add(request)
        
        //cancel all notifications
        //center.removeAllPendingNotificationRequests()
    }
    
    func registerCategories() {
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        //pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            
            print("Custom data received: \(customData)")
            
            switch  response.actionIdentifier {
                
            case UNNotificationDefaultActionIdentifier:
                //the user swiped to unlock
                print("Default identifier")
                
            case "show":
                //the user tapped our "show more info..." button
                print("Show more information...")
                break
                
            default:
                break
            }
        }
        //you must call the completion handler when you're done
        completionHandler()
    }

}

