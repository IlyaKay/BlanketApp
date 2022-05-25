//
//  BlanketAppApp.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//
// Orientation lock code provided by https://stackoverflow.com/questions/66037782/swiftui-how-do-i-lock-a-particular-view-in-portrait-mode-whilst-allowing-others

import SwiftUI

@main
struct BlanketAppApp: App {
    
    @StateObject var planListModel: PlanListModel = PlanListModel()
    @StateObject var activePlanListModel: ActivePlanListModel = ActivePlanListModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(planListModel)
            .environmentObject(activePlanListModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
