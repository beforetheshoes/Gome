//
//  GomeApp.swift
//  Gome
//
//  Created by Ryan Williams on 4/22/25.
//

import SwiftUI
import SwiftData

@main
struct GomeApp: App {
    @StateObject private var userSettings = UserSettings.shared

    var body: some Scene {
        WindowGroup {
            HabitListView()
                .environmentObject(userSettings)
        }
        .modelContainer(for: [Habit.self, HabitRecord.self])
    }
}
