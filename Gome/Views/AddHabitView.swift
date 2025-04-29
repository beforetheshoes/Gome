//
//  AddHabitView.swift
//  Gome
//
//  Created by Ryan Williams on 4/22/25.
//

import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var name = ""
    @State private var goalThreshold = 3
    @State private var interval: GoalInterval = .week

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Habit Name
                    TextField("Name", text: $name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                    
                } header: {
                    Text("Habit Name")
                }
                
                Section {
                    // Goal Picker
                    Picker("Goal", selection: $goalThreshold) {
                        ForEach(1...100, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    .pickerStyle(WheelPickerStyle()) // Wheel style for number selection
                    .frame(height: 100) // Adjust height for a smaller, more consistent size
                    .clipped()
                } header: {
                    Text("Completions Goal")
                }
                
                Section {
                    // Interval Picker
                    Picker("Interval", selection: $interval) {
                        ForEach(GoalInterval.allCases, id: \.self) { interval in
                            Text(interval.rawValue.capitalized)
                                .tag(interval as GoalInterval)
                        }
                    }
                    .pickerStyle(.menu) // Menu style for interval selection
                } header: {
                    Text("Goal Interval")
                }
            }
            .navigationTitle("New Habit")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newHabit = Habit(
                            name: name,
                            goalThreshold: goalThreshold,
                            primaryInterval: interval
                        )
                        modelContext.insert(newHabit)
                        try? modelContext.save()
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
