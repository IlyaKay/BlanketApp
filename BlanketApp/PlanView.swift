//
//  PlanView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct PlanView: View {
    
    @EnvironmentObject var planListModel: PlanListModel
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Activate a plan:")
                    .font(.system(size:21,weight:.medium,design:.default))
                if planListModel.planList.isEmpty {
                    Text("No plans yet")
                } else {
                    List {
                        ForEach(planListModel.planList) { plan in
                            Text(plan.planTitle)
                        }
                        .onDelete(perform: planListModel.deletePlan)
                        .onMove(perform: planListModel.movePlan)
                    }
                    .listStyle(PlainListStyle())
                }
                NavigationLink("Create a new plan!", destination: CreatePlanView())
            }
            .navigationBarTitle("Planning 🗺")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink("Add", destination: CreatePlanView()))
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
