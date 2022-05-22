//
//  MainView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Target Bedtime:")
                        .font(.system(size:21,weight:.medium,design:.default))
                }
                VStack {
                    Text("Target Sleep Length:")
                        .font(.system(size:21,weight:.medium,design:.default))
                }
                Text("contact.name")
                    .font(.headline)
                Text("contact.phone")
                    .foregroundColor(.gray)
                    .font(.callout)
                Section {
                    Button(action: {
                        print("Call staff member \("contact.phone")")
                    }) {
                        Text("Call \("contact.name")")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                    }
                    Link("Go to staff profile", destination: URL(string: "contact.profile")!)
                }
                Spacer()
            }
        }
        .navigationBarTitle("Blanket")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
