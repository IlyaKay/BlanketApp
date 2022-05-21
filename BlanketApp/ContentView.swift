//
//  ContentView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 0

    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                MainView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
             
                Text("Planning Tab")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "bookmark.circle.fill")
                        Text("Plan")
                    }
                    .tag(1)
            }
            
            .navigationBarTitle("Blanket")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}