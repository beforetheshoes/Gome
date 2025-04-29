//
//  Habit+Extensions.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import Foundation

extension Habit {
    static var preview: Habit {
        let habit = Habit(name: "Read a Book", goalThreshold: 1, primaryInterval: .day)
        habit.records.append(HabitRecord(dateCompleted: .now, habit: habit))
        habit.records.append(HabitRecord(dateCompleted: Calendar.current.date(byAdding: .day, value: -1, to: .now)!, habit: habit))
        return habit
    }
    
    func removeLastRecordInCurrentInterval() {
        let currentInterval = self.primaryInterval.currentDateInterval()
        if let lastRecord = self.records
            .filter({ currentInterval.contains($0.dateCompleted) })
            .sorted(by: { $0.dateCompleted > $1.dateCompleted })
            .first {
            self.records.removeAll { $0.id == lastRecord.id }
        }
    }

    func addRecord(date: Date = .now) {
        let newRecord = HabitRecord(dateCompleted: date, habit: self)
        self.records.append(newRecord)
    }
}
