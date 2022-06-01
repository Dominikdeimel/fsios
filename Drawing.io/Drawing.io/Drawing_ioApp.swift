//
//  Drawing_ioApp.swift
//  Drawing.io
//
//  Created by Dominik Deimel on 01.03.22.
//

import SwiftUI
import UserNotifications

@main
struct Drawing_ioApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var databaseController: DatabaseController
    @StateObject private var viewModel: ViewModel
    
    init() {
        
        let db = DatabaseController()
        self._databaseController = StateObject(wrappedValue: db)
        self._viewModel = StateObject(wrappedValue: ViewModel(context: db.container.viewContext))
        
    }
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environment(\.managedObjectContext, databaseController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let userPrefs = UserPreferencesKeys()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerForPushNotifications()
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                    print("Permission granted: \(granted)")
                    guard granted else { return }
                    self?.getNotificationSettings()
                }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        UserDefaults.standard.set(token, forKey: userPrefs.deviceToken)
        
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
}
