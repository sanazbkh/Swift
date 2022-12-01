//
//  ViewController.swift
//  Notification
//
//  Created by sanaz bahmankhah on 30/11/2022.
//

import UIKit
import UserNotifications

final class ViewController: UIViewController {
    private let center = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal() {
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("User gave permission")
            } else {
                print("permission denied")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let content = UNMutableNotificationContent()
        content.title = "woman life freedom"
        content.body = "Do not doubt.. we are victorious"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        self.center.add(request)
    }
}

