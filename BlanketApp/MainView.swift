//
//  MainView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var activePlanListModel: ActivePlanListModel
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Target Bedtime:")
                        .font(.system(size:21,weight:.medium,design:.default))
                    Text("\(activePlanListModel.activePlanList[0].bedTime, style: .time)")
                        .font(.system(size:30,weight:.medium,design:.default))
                }
                VStack {
                    Text("Set alarm for:")
                        .font(.system(size:21,weight:.medium,design:.default))
                    Text("\(activePlanListModel.activePlanList[0].alarmTime, style: .time)")
                        .font(.system(size:30,weight:.medium,design:.default))
                }
//                Text("contact.name")
//                    .font(.headline)
//                Text("contact.phone")
//                    .foregroundColor(.gray)
//                    .font(.callout)
//                Section {
//                    Button(action: {
//                        print("Call staff member \("contact.phone")")
//                    }) {
//                        Text("Call \("contact.name")")
//                            .font(.system(size: 30, weight: .bold, design: .rounded))
//                    }
//                    Link("Go to staff profile", destination: URL(string: "contact.profile")!)
//                }
                if activePlanListModel.activePlanList.isEmpty {
                    Text("No plans yet")
                } else {
                    List {
                        ForEach(activePlanListModel.activePlanList) { plan in
                            HStack {
                                Text(plan.bedTime, style: .date)
                                Text(plan.bedTime, style: .time)
                                Text(plan.alarmTime, style: .time)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
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
