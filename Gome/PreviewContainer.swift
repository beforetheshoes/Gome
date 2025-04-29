//
//  PreviewContainer.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import SwiftData
import Foundation

@MainActor
struct PreviewContainer {
    static let container: ModelContainer = {
        do {
            let schema = Schema([
                Habit.self,
                HabitRecord.self
            ])
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: schema, configurations: config)

            // Insert preview data
            let context = container.mainContext

            for habit in PreviewData.habits {
                context.insert(habit)
                for record in habit.records {
                    context.insert(record)
                }
            }

            return container
        } catch {
            fatalError("Failed to create preview container: \(error)")
        }
    }()
}
