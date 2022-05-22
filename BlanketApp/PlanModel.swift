//
//  PlanModel.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import Foundation

struct PlanModel: Identifiable, Codable {
    let id: String
    let planTitle: String
    let wakeTime: Date
    let correctionPeriod: Int
    let sleepLength: Int
    
    init(id: String = UUID().uuidString, planTitle: String, wakeTime: Date, correctionPeriod: Int, sleepLength: Int) {
        self.id = id
        self.planTitle = planTitle
        self.wakeTime = wakeTime
        self.correctionPeriod = correctionPeriod
        self.sleepLength = sleepLength
    }
    
}

class PlanListModel: ObservableObject {
    
    @Published var planList: [PlanModel] = [] {
        didSet {
            savePlans()
        }
    }
    
    let planKey: String = "plan_list"
    
    init() {
        getPlanList()
    }
    
    func getPlanList() {
        guard
            let data = UserDefaults.standard.data(forKey: planKey),
            let savePlans = try? JSONDecoder().decode([PlanModel].self, from: data)
        else { return }

        self.planList = savePlans
    }
    
    func movePlan(from: IndexSet, to: Int) {
        planList.move(fromOffsets: from, toOffset: to)
    }
    
    func deletePlan(indexSet: IndexSet) {
        planList.remove(atOffsets: indexSet)
    }
    
    func addPlan(planTitle: String, wakeTime: Date, correctionPeriod: Int, sleepLength: Int) {
        let newPlan = PlanModel(planTitle: planTitle, wakeTime: wakeTime, correctionPeriod: correctionPeriod, sleepLength: sleepLength)
        planList.append(newPlan)
    }
    
    func savePlans() {
        if let encodedData = try? JSONEncoder().encode(planList) {
            UserDefaults.standard.set(encodedData, forKey: planKey)
        }
    }
}
