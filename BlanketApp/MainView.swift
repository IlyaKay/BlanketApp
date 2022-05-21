//
//  MainView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 21/05/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
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
            Form {
                HStack {
                    Text("Phone")
                    Spacer()
                    Text("contact.phone")
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Email")
                    Spacer()
                    Text("contact.email")
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                HStack {
                    Text("Role")
                    Spacer()
                    Text("contact.role")
                        .foregroundColor(.gray)
                        .font(.callout)
                }
                Section {
                    Button(action: {
                        print("Call staff member \("contact.phone")")
                    }) {
                        Text("Call \("contact.name")")
                    }
                    Link("Go to staff profile", destination: URL(string: "contact.profile")!)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
