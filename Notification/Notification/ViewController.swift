//
//  ViewController.swift
//  Notification
//
//  Created by sanaz bahmankhah on 30/11/2022.
//

import UIKit
import UserNotifications
import WebKit

enum WebURL {
    case breakingNews
    case latestNews
    
    var url: String {
        switch self {
        case .breakingNews:
            return "https://us.cnn.com/?iref=intlglobal/index.html"
        case .latestNews:
            return "https://edition.cnn.com/"
        }
    }
}

final class ViewController: UIViewController {
    private let center = UNUserNotificationCenter.current()
    private let webView = WKWebView()
    
    override func loadView() {
        showView(webUrl: .latestNews)
    }
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
                print("Permission denied")
            }
        }
    }
    
    @objc func scheduleLocal() {
        self.registerCategories()
        let content = UNMutableNotificationContent()
        content.title = "Breaking news"
        content.body = "Find the latest breaking news and information"
        content.categoryIdentifier = "alarm"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5 , repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        self.center.add(request)
    }
    
    func registerCategories() {
        self.center.delegate = self
        let breakingNews = UNNotificationAction(identifier: "breakingNews", title: "Breaking news", options: .foreground)
        let latestNews = UNNotificationAction(identifier: "latestNews", title: "Today's latest news", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [breakingNews , latestNews], intentIdentifiers: [])
        self.center.setNotificationCategories([category])
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            print("default identifier")
        case "breakingNews":
            showView(webUrl: .breakingNews)
        case "latestNews":
            showView(webUrl: .latestNews)
        default:
            break
        }
        completionHandler()
    }
    
    func showView(webUrl: WebURL) {
        guard let url = URL(string: webUrl.url) else { return }
        self.view = webView
        webView.load(URLRequest(url: url))
    }
}
