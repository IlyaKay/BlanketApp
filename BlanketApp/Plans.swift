//
//  Plans.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import SwiftUI

class Plan: Identifiable, Codable {
    var planTitle: String = ""
    var wakeTime = Date()
    var correctionPeriod = 3
    var sleepLength = 8
    
}

@MainActor class Plans: ObservableObject {
    @Published private(set) var profiles: [Plan]
    let saveKey = "SavedData"

    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decoded = try? JSONDecoder().decode([Plan].self, from: data) {
                profiles = decoded
                return
            }
        }

        // no saved data!
        profiles = []
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    func add(_ plan: Plan) {
        profiles.append(plan)
        save()
    }
}
