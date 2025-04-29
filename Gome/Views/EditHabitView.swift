//
//  EditHabitView.swift
//  Gome
//
//  Created by Ryan Williams on 4/24/25.
//

import SwiftUI
import SwiftData

struct EditHabitView: View {
    @Bindable var habit: Habit
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    // Habit Name
                    TextField("Name", text: $habit.name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                    
                } header: {
                    Text("Habit Name")
                }
                
                Section {
                    // Goal Picker
                    Picker("Goal", selection: $habit.goalThreshold) {
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
                    Picker("Interval", selection: $habit.primaryInterval) {
                        ForEach(GoalInterval.allCases, id: \.self) { interval in
                            Text(interval.rawValue.capitalized)
                                .tag(interval as GoalInterval)
                        }
                    }
                    .pickerStyle(.menu) // Menu style for interval selection
                } header: {
                    Text("Goal Interval")
                }
                
                Section {
                    Button("Delete Habit") {
                        deleteHabit()
                    }
                    .foregroundColor(.red) // To indicate danger
                    .alert(isPresented: $showingDeleteConfirmation) {
                        Alert(
                            title: Text("Are you sure?"),
                            message: Text("This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                confirmDeleteHabit()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @State private var showingDeleteConfirmation = false
    
    private func deleteHabit() {
        showingDeleteConfirmation = true
    }
    
    private func confirmDeleteHabit() {
        // Here you would implement the logic to actually delete the habit
        modelContext.delete(habit)
        do {
            try modelContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    let example = Habit(name: "A Great Habit", goalThreshold: 3, primaryInterval: .day)
    
    EditHabitView(habit: example).modelContainer(container)
}
