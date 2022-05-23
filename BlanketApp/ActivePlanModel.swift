//
//  ActivePlanModel.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import Foundation

struct ActivePlanModel: Identifiable, Codable {
    let id: String
    let bedTime: Date
    let alarmTime: Date
    
    init(id: String = UUID().uuidString, bedTime: Date, alarmTime: Date) {
        self.id = id
        self.bedTime = bedTime
        self.alarmTime = alarmTime
    }
}

class ActivePlanListModel: ObservableObject {
    
    @Published var activePlanList: [ActivePlanModel] = [] {
        didSet {
            savePlans()
        }
    }
    
    let bedKey: String = "bedtime_list"
    
    init() {
        getPlanList()
    }
    
    func getPlanList() {
        guard
            let data = UserDefaults.standard.data(forKey: bedKey),
            let savePlans = try? JSONDecoder().decode([ActivePlanModel].self, from: data)
        else { return }

        self.activePlanList = savePlans
    }
    
    func savePlans() {
        if let encodedData = try? JSONEncoder().encode(activePlanList) {
            UserDefaults.standard.set(encodedData, forKey: bedKey)
        }
    }
    
    func buildPlan(plan: PlanModel, currentBedTime: Date) {
        activePlanList.removeAll()
        let calendar = Calendar.current
        
        let startHour = (calendar.component(.hour, from: currentBedTime))
        var startMinute = (startHour * 60) + (calendar.component(.minute, from: currentBedTime))
        
        let finalHour = (calendar.component(.hour, from: plan.wakeTime))
        let finalMinute = (finalHour * 60) + (calendar.component(.minute, from: plan.wakeTime))
        
        startMinute = startMinute + (plan.sleepLength * 60)
        let difference = abs(finalMinute - startMinute)
        
        let interval = round(Double(difference / plan.correctionPeriod))
        
        for i in 1..<(plan.correctionPeriod) {
            let nextInterval = interval * Double(i)
            let bedTime = currentBedTime.addingTimeInterval(TimeInterval(Int(nextInterval) * 60))
            let alarmTime = bedTime.addingTimeInterval(TimeInterval(Int(plan.sleepLength) * 60 * 60))
//            var bedTime = calendar.date(byAdding: .minute, value: Int(interval), to: currentBedTime)
//            var alarmTime = calendar.date(byAdding: .hour, value: plan.sleepLength, to: bedTime)
            
            let newWindow = ActivePlanModel(bedTime: bedTime, alarmTime: alarmTime)
            activePlanList.append(newWindow)
        }
        
        let bedTime = plan.wakeTime.addingTimeInterval(-(Double(Int(plan.sleepLength) * 60 * 60)))
        let newWindow = ActivePlanModel(bedTime: bedTime, alarmTime: plan.wakeTime)
        activePlanList.append(newWindow)
        
//            startMinute = ((startMinute + Int(interval)) % 1440)
//            startHour = (Int)(floor(Double(startMinute / 60)))
//            startMinute = startMinute % 60
        
//        let date = calendar.date(bySettingHour: startHour, minute: startMinute, second: 0, of: Date())!
//        let newWindow = ActivePlanModel(bedTime: bedTime, alarmTime: alarmTime)
//        activePlanList = finalPlan
//        activePlanList.append(finalPlan)
    }
    
    func deletePlan(indexSet: IndexSet) {
        activePlanList.remove(atOffsets: indexSet)
    }
}
