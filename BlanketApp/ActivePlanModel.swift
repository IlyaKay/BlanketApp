//
//  ActivePlanModel.swift
//  BlanketApp
//
//  Created by Ilya Kiselev on 10/05/2022.
//

import Foundation
import UserNotifications

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
        // remove any existing active plans
        activePlanList.removeAll()
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        
        // extract hours and minutes from current bedtime
        let startHour = (calendar.component(.hour, from: currentBedTime))
        var startMinute = (startHour * 60) + (calendar.component(.minute, from: currentBedTime))
        
        // extract hours and minutes from planned wakeup time
        let finalHour = (calendar.component(.hour, from: plan.wakeTime))
        let finalMinute = (finalHour * 60) + (calendar.component(.minute, from: plan.wakeTime))
        
        // calculate the amount of time that the sleep schedule shifts every day
        startMinute = startMinute + (plan.sleepLength * 60)
        var difference = finalMinute - startMinute
        if difference > 720 {
            difference = difference - 1440
        } else if difference < -720 {
            difference = difference + 1440
        }
        let interval = (difference / plan.correctionPeriod)
        
        for i in 1..<(plan.correctionPeriod) {
            // calculate the exact time and date that the user should go to bed and wake up
            dateComponent.day = i
            let nextInterval = round(Double(interval * i))
            var bedTime = currentBedTime.addingTimeInterval(TimeInterval(Int(nextInterval) * 60))
            bedTime = calendar.date(byAdding: dateComponent, to: bedTime)!
            let alarmTime = bedTime.addingTimeInterval(TimeInterval(Int(plan.sleepLength) * 60 * 60))
            activePlanList.append(ActivePlanModel(bedTime: bedTime, alarmTime: alarmTime))
            
            // setup a timer to remove the plan when it is used up (at its alarmTime)
            let timer = Timer(fireAt: alarmTime, interval: 0, target: self, selector: #selector(deleteTopPlan), userInfo: nil, repeats: false)
            RunLoop.main.add(timer, forMode: .common)
        }
        // final day can use the target bed and alarm time to account for the rounding errors in nextInterval
        dateComponent.day = plan.correctionPeriod
        var bedTime = currentBedTime.addingTimeInterval(TimeInterval(Int(difference) * 60))
        bedTime = calendar.date(byAdding: dateComponent, to: bedTime)!
        activePlanList.append(ActivePlanModel(bedTime: bedTime, alarmTime: plan.wakeTime))
        
        // no timer to delete this plan to leave the correct schedule on the main screne
        
        // attempt to activate notifications
        activateNotifications()
        
        // DEMO/TESTING remove top plan after 10 seconds
        let timer = Timer(fireAt: Date.now.addingTimeInterval(10), interval: 0, target: self, selector: #selector(deleteTopPlan), userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
        
    }
    
    func activateNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                let calendar = Calendar.current
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
                dateFormatter.dateFormat = "HH:mm" // or "hh:mm a"

                // clear any remaining notifications left from previous active plans
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                
                for plan in self.activePlanList {
                    
                    // Primary Notification //
                    
                    let bedTimeForm = dateFormatter.string(from: plan.bedTime)
                    let alarmTimeForm = dateFormatter.string(from: plan.alarmTime)
                    
                    // fill out notification contents
                    let content = UNMutableNotificationContent()
                    content.title = "Bedtime Reminder"
                    content.body = "Make sure to go to bed at \(bedTimeForm)\nAnd set your alarm at \(alarmTimeForm)"
                    content.sound = UNNotificationSound.default

                    // setup a trigger time that the notification shows
                    var triggerTime = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: calendar.date(byAdding: .hour, value: -1, to: plan.bedTime)!)
                    var trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
                    
                    // show this notification 1 hour before bedtime
                    var request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                    
                    // Secondary notification //
                    
                    // reform notification contents
                    content.title = "Bedtime Soon"
                    content.body = "Make sure you go to bed at \(bedTimeForm) to get your full night's rest!"
                    
                    // setup a new trigger
                    triggerTime = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: calendar.date(byAdding: .minute, value: -5, to: plan.bedTime)!)
                    trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: false)
                    
                    // show this notification 5 minutes before bedtime
                    request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                    // add our notification request
                    UNUserNotificationCenter.current().add(request)
                    
                    // DEMO/TESTING send a notification after 20 seconds
                    content.title = "Bedtime Reminder"
                    content.body = "Make sure you go to bed at \(bedTimeForm) to get your full night's rest!"
                    let testTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
                    request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: testTrigger)
                    UNUserNotificationCenter.current().add(request)
                    
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func deleteTopPlan() {
        activePlanList.removeFirst()
    }
}
