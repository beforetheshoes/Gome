//
//  HabitListView.swift
//  Gome
//
//  Created by Ryan Williams on 4/22/25.
//

import SwiftUI
import SwiftData

struct HabitListView: View {
    @Query private var habits: [Habit]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userSettings: UserSettings
    @State private var activeSheet: ActiveSheet?

    enum ActiveSheet: Identifiable {
        case addHabit
        case settings
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if habits.isEmpty {
                    ContentUnavailableView("Add your first habit!", systemImage: "circle.dotted")
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 16)], spacing: 16) {
                        ForEach(habits) { habit in
                            HabitTileView(habit: habit)
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let habit = habits[index]
                                modelContext.delete(habit)
                            }
                            
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Gome")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        userSettings.useDarkMode.toggle()
                    } label: {
                        Image(systemName: userSettings.useDarkMode ? "sun.max.fill" : "moon.fill")
                            .imageScale(.large)
                    }
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        activeSheet = .settings
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .imageScale(.large)
                    }
                }
            }
            .sheet(item: $activeSheet) { sheet in
                switch sheet {
                case .addHabit:
                    AddHabitView()
                    
                case .settings:
                    NavigationStack {
                        SettingsView(settings: userSettings)
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                activeSheet = .addHabit
            }) {
                Label("Add Habit", systemImage: "plus")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    
            }
            .padding(.horizontal)
        }
        .environmentObject(UserSettings.shared)
        .preferredColorScheme(userSettings.useDarkMode ? .dark : .light)
    }
}

#Preview {
    HabitListView()
        .environmentObject(UserSettings.shared)
        .modelContainer(PreviewContainer.container)
}
