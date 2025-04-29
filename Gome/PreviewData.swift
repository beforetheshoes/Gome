//
//  PreviewData.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import Foundation

struct PreviewData {
    static let habits: [Habit] = {
        let calendar = Calendar.current
        let today = Date()
        let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: today)!

        var habits: [Habit] = []

        // Define 6 habits with different settings
        let habitConfigs: [(name: String, goalThreshold: Int, interval: GoalInterval)] = [
            ("Daily Workout", 1, .day),
            ("Read Book", 1, .day),
            ("Meditate", 3, .week),
            ("Journal", 2, .week),
            ("Budget Review", 1, .month),
            ("Clean House", 2, .month)
        ]
        
        func randomTime(of date: Date) -> Date {
            let calendar = Calendar.current
            let randomHour = Int.random(in: 6...22) // Active hours: 6 AM - 10 PM
            let randomMinute = Int.random(in: 0..<60)
            return calendar.date(bySettingHour: randomHour, minute: randomMinute, second: 0, of: date) ?? date
        }

        for config in habitConfigs {
            let habit = Habit(name: config.name, goalThreshold: config.goalThreshold, primaryInterval: config.interval)
            
            // Generate records for 2 months
            var currentDate = twoMonthsAgo
            
            while currentDate <= today {
                switch config.interval {
                case .day:
                    // Randomly skip some days for imperfection
                    if Bool.random() || Bool.random() { // About 75% chance to complete
                        habit.records.append(HabitRecord(dateCompleted: randomTime(of: currentDate), habit: habit))
                    }
                    currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                    
                case .week:
                    // Randomly complete 2-4 times per week
                    for _ in 0..<(Int.random(in: 2...4)) {
                        if let randomDayInWeek = calendar.date(byAdding: .day, value: Int.random(in: 0...6), to: currentDate) {
                            habit.records.append(HabitRecord(dateCompleted: randomTime(of: randomDayInWeek), habit: habit))
                        }
                    }
                    currentDate = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate)!
                    
                case .month:
                    // 1-3 completions per month
                    for _ in 0..<(Int.random(in: 1...3)) {
                        if let randomDayInMonth = calendar.date(byAdding: .day, value: Int.random(in: 0...30), to: currentDate) {
                            habit.records.append(HabitRecord(dateCompleted: randomTime(of: randomDayInMonth), habit: habit))
                        }
                    }
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
                }
            }

            habits.append(habit)
        }

        return habits
    }()
}
