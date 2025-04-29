//
//  HabitRecords+Extensions.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import Foundation

extension HabitRecord {
    static func preview(for habit: Habit) -> HabitRecord {
        HabitRecord(dateCompleted: .now, habit: habit)
    }
}
