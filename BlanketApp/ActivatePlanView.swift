//
//  ActivatePlanView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

struct ActivatePlanView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var activePlanListModel: ActivePlanListModel
    
    let plan: PlanModel
    
    @State private var bedTime: Date = Date()
    @Binding var tabSelection: Int
    
    var body: some View {
        Form {
            Section {
                Text("Aim to sleep \(plan.sleepLength) hrs a night over \(plan.correctionPeriod) days.")
            }
            
            DatePicker("Bedtime from last night:", selection: $bedTime, displayedComponents: .hourAndMinute)
            
//            Text(plan.wakeTime, style: .date)
            
            Button("Activate plan!") {
                activePlanListModel.buildPlan(plan: plan, currentBedTime: bedTime)
                presentationMode.wrappedValue.dismiss()
                tabSelection = 0
            }
            .font(.headline)
        }
        .navigationTitle(plan.planTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ActivatePlanView_Previews: PreviewProvider {
    static var previews: some View {
        ActivatePlanView(plan: PlanModel.example, tabSelection: .constant(0))
    }
}
