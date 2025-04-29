//
//  Habit.swift
//  Gome
//
//  Created by Ryan Williams on 4/23/25.
//

import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var name: String
    var creationDate: Date
    var goalThreshold: Int
    var primaryInterval: GoalInterval
    @Relationship(deleteRule: .cascade) var records: [HabitRecord] = []

    init(name: String, goalThreshold: Int, primaryInterval: GoalInterval) {
        self.id = UUID()
        self.name = name
        self.creationDate = .now
        self.goalThreshold = goalThreshold
        self.primaryInterval = primaryInterval
    }
}

enum GoalInterval: String, CaseIterable, Codable, Hashable {
    case day
    case week
    case month

    func currentDateInterval() -> DateInterval {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .day:
            return calendar.dateInterval(of: .day, for: now)!
        case .week:
            return calendar.dateInterval(of: .weekOfYear, for: now)!
        case .month:
            return calendar.dateInterval(of: .month, for: now)!
        }
    }
}

extension Habit {
    func completions(in interval: GoalInterval) -> Int {
        let dateInterval = interval.currentDateInterval()
        return records.filter { dateInterval.contains($0.dateCompleted) }.count
    }
    
    var completionsToday: Int {
        completions(in: .day)
    }
    
    var completionsThisWeek: Int {
        completions(in: .week)
    }
    
    var completionsThisMonth: Int {
        completions(in: .month)
    }
    
    func goalMet(for interval: GoalInterval) -> Bool {
        return completions(in: interval) >= goalThreshold
    }
}

extension Habit {
    
    func completions(for date: Date, interval: GoalInterval) -> Int {
        let calendar = Calendar.current
        let currentInterval: DateInterval
        
        switch interval {
        case .day:
            currentInterval = calendar.dateInterval(of: .day, for: date)!
        case .week:
            currentInterval = calendar.dateInterval(of: .weekOfYear, for: date)!
        case .month:
            currentInterval = calendar.dateInterval(of: .month, for: date)!
        }
        
        return records.filter { currentInterval.contains($0.dateCompleted) }.count
    }
    
    func isGoalMet(for date: Date, interval: GoalInterval) -> Bool {
        return completions(for: date, interval: interval) >= goalThreshold
    }
    
    // Primary interval progress
    var primaryCompletions: Int {
        completions(in: primaryInterval)
    }
    
    var primaryGoalMet: Bool {
        goalMet(for: primaryInterval)
    }
    
    // Helper to figure out monthly slices
    func monthlySlices(forMonth monthDate: Date) -> Int {
        let calendar = Calendar.current
        switch primaryInterval {
        case .day:
            return calendar.range(of: .day, in: .month, for: monthDate)?.count ?? 30
        case .week:
            let interval = calendar.dateInterval(of: .month, for: monthDate)!
            let weeks = calendar.dateComponents([.weekOfMonth], from: interval.start, to: interval.end).weekOfMonth ?? 4
            return weeks
        case .month:
            return max(goalThreshold, 1)
        }
    }
    
    // Get slices info for current month
    func monthRingData() -> [Bool] {
        let calendar = Calendar.current
        let now = Date()
        
        switch primaryInterval {
        case .day:
            guard let range = calendar.range(of: .day, in: .month, for: now) else { return [] }
            return range.map { day in
                let date = calendar.date(bySetting: .day, value: day, of: now)!
                return isGoalMet(for: date, interval: .day)
            }
            
        case .week:
            let monthInterval = calendar.dateInterval(of: .month, for: now)!
            var data: [Bool] = []
            var weekStart = monthInterval.start
            
            while weekStart < monthInterval.end {
                let completionsThisWeek = completions(for: weekStart, interval: .week)
                data.append(completionsThisWeek >= goalThreshold)
                
                if let nextWeek = calendar.date(byAdding: .day, value: 7, to: weekStart) {
                    weekStart = nextWeek
                } else {
                    break
                }
            }
            return data
            
        case .month:
            // Slice into "goalThreshold" parts, mark completion thresholds
            let totalCompletions = completions(in: .month)
            let perSlice = max(1, totalCompletions / goalThreshold)
            
            return (0..<goalThreshold).map { index in
                let completionsForThisSlice = index * perSlice
                return completionsForThisSlice < totalCompletions
            }
        }
    }
}

@Model
final class HabitRecord {
    @Attribute var dateCompleted: Date
    @Relationship(inverse: \Habit.records) var habit: Habit?
    var id: UUID
    var note: String?
    
    init(dateCompleted: Date = .now, habit: Habit, notes: String? = nil) {
        self.dateCompleted = dateCompleted
        self.habit = habit
        self.id = UUID()
        self.note = notes
    }
}
