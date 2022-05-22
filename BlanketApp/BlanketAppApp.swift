//
//  BlanketAppApp.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

@main
struct BlanketAppApp: App {
    
    @StateObject var planListModel: PlanListModel = PlanListModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(planListModel)
        }
    }
}
