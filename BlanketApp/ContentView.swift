//
//  ContentView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("Background"))
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            MainView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            PlanView(tabSelection: $tabSelection)
                .tabItem {
                    Label("Plan", systemImage: "bookmark.circle.fill")
                }
                .tag(1)
        }
        .accentColor(Color("SelectedIcon"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
