//
//  MainView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var activePlanListModel: ActivePlanListModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if (colorScheme == .dark) {
                    Image("Night")
                        .resizable()
                        .ignoresSafeArea()
                } else {
                    Image("Day")
                        .resizable()
                        .ignoresSafeArea()
                }
                
                
                VStack {
                    Spacer(minLength: 30)
                    VStack {
                        Text("Bedtime tonight:")
                            .font(.system(size:21,weight:.medium,design:.rounded))
                        Text("\(activePlanListModel.activePlanList[0].bedTime, style: .time)")
                            .font(.system(size:30,weight:.medium,design:.default))
                    }
                    Spacer(minLength: 15)
                    VStack {
                        Text("Set alarm for:")
                            .font(.system(size:21,weight:.medium,design:.rounded))
                        Text("\(activePlanListModel.activePlanList[0].alarmTime, style: .time)")
                            .font(.system(size:30,weight:.medium,design:.default))
                    }
    //                Text("contact.name")
    //                    .font(.headline)
    //                Text("contact.phone")
    //                    .foregroundColor(.gray)
    //                    .font(.callout)
                    Spacer(minLength: 90)
                    VStack {
                        Text("Current sleep plan:")
                            .font(.system(size:21,weight:.medium,design:.rounded))
                        if activePlanListModel.activePlanList.isEmpty {
                            Text("No plans yet")
                        } else {
                            List {
                                ForEach(activePlanListModel.activePlanList) { plan in
                                    HStack {
                                        Text(plan.bedTime, style: .date)
                                        Spacer()
                                        Text(plan.bedTime, style: .time)
                                        Text("-")
                                        Text(plan.alarmTime, style: .time)
                                    }
                                    .listRowBackground(Color.white.opacity(0))
                                }
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    .foregroundColor(Color(.white))
                    Spacer()
                }
                .navigationBarTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
            }
        }.onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
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
