//
//  PlanView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct PlanView: View {
    @EnvironmentObject var planListModel: PlanListModel
    @Binding var tabSelection: Int
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Activate a plan:")
                    .font(.system(size:21,weight:.medium,design:.default))
                if planListModel.planList.isEmpty {
                    Spacer(minLength: 30)
                    Text("No plans yet")
                        .font(.system(size:30,weight:.medium,design:.default))
                    Text("Click add in the top right to create a new plan!")
                        .font(.system(size:20,weight:.medium,design:.default))
                        .multilineTextAlignment(.center)
                }
                List {
                    ForEach(planListModel.planList) { plan in
                        NavigationLink(destination: ActivatePlanView(plan: plan, tabSelection: $tabSelection)) {
                            HStack {
                                Text(plan.planTitle)
                                Spacer()
                                Text(plan.wakeTime, style: .time)
                                Text("\(plan.correctionPeriod)d")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .padding(6)
                                    .background(.green)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                                Text("\(plan.sleepLength)h")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .padding(6)
                                    .background(.blue)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }
                        }
                        .listRowBackground(Color.green.opacity(0))
                    }
                    .onDelete(perform: planListModel.deletePlan)
                    .onMove(perform: planListModel.movePlan)
                }
                .listStyle(PlainListStyle())
                Text("") // Fixes tabbar colour
            }
            .navigationBarTitle("Planning") // 🗺
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: EditButton(), trailing: NavigationLink("Add", destination: CreatePlanView()))
            .background(Color("Background"))
        }
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(tabSelection: .constant(1))
    }
}
