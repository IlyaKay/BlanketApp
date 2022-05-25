//
//  CreatePlanView.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 22/05/2022.
//

import SwiftUI

struct CreatePlanView: View {
    
    init(){
        UITableView.appearance().backgroundColor = .clear
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var planListModel: PlanListModel
    
    @State private var planTitle: String = ""
    @State private var wakeTime: Date = Date()
    @State private var correctionPeriod: Int = 5
    @State private var sleepLength: Int = 4
    
    @State private var ignoreWarning: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .center) {
                    Text("Title:")
                        .font(.callout)
                        .bold()
                    TextField("Plan name...", text: $planTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                DatePicker("Target time to wake up:", selection: $wakeTime, displayedComponents: .hourAndMinute)
                Picker("Nights to correct over:", selection: $correctionPeriod) {
                    ForEach(2..<29) {
                        Text("\($0) nights")
                    }
                }
                Picker("Length of sleep per day:", selection: $sleepLength) {
                    ForEach(4..<11) {
                        Text("\($0) hours")
                    }
                }
            }
            Button(action: saveNewPlan, label: {
                Text("Save")
            })
        }
        .navigationBarTitle("Add Plan")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showAlert, content: getAlert)
        .background(Color("Background"))
    }
    
    func saveNewPlan() {
        if validateFields() {
            planListModel.addPlan(planTitle: planTitle, wakeTime: wakeTime, correctionPeriod: correctionPeriod + 2, sleepLength: sleepLength + 4)
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func validateFields() -> Bool {
        if sleepLength < 3 && !ignoreWarning{
            alertTitle = "Health Warning"
            alertMessage = "It is not recommended to regularly sleep less than 7 hours!"
            showAlert = true
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(
            title: Text(alertTitle),
            message: Text(alertMessage),
            primaryButton: .destructive(Text("Continue")) {
                ignoreWarning = true
            },
            secondaryButton: .cancel(Text("Cancel"))
        )
    }
}


struct CreatePlanView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePlanView()
    }
}
