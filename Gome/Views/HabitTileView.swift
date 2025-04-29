//
//  HabitTileView.swift
//  Gome
//
//  Created by Ryan Williams on 4/22/25.
//

import SwiftUI

struct HabitTileView: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @State private var activeSheet: ActiveSheet?
    
    enum ActiveSheet: Identifiable {
        case edit
        case completions([HabitRecord])

        var id: String {
            switch self {
            case .edit:
                return "edit"
            case .completions:
                return "completions"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                VStack {
                    HStack {
                        Button {
                            decrementHabit()
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black, .red)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        Button {
                            incrementHabit()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.black, .green)
                                .overlay(
                                    Circle()
                                        .stroke(.black, lineWidth: 1)
                                )
                        }
                        .padding(.trailing, 8)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)

                ConcentricRingsView(habit: habit)
                    .frame(width: 120, height: 120)
                    .padding(.top, 10)
            }
            .frame(height: 110)
            
            Text(habit.name)
                .font(.caption)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 34)
                .frame(maxWidth: .infinity)
        }
        .frame(width: 160, height: 160)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: 0xfef1e6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(habit.primaryGoalMet ? Color.green : Color.clear, lineWidth: 4) // Green border when on track
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .dark ? .white : .black, lineWidth: 1)
        )
        .shadow(radius: 4)
        .onTapGesture {
            activeSheet = .completions(getCompletionsForCurrentMonth())
        }
        .onLongPressGesture {
            activeSheet = .edit
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .edit:
                EditHabitView(habit: habit)
            case .completions(let completions):
                CompletionListView(completions: completions)
            }
        }
    }
    
    func getCompletionsForCurrentMonth() -> [HabitRecord] {
        let calendar = Calendar.current
        let now = Date()

        // Get the start and end of the current month
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        // Filter completions that occurred within the current month
        return habit.records.filter({ startOfMonth <= $0.dateCompleted && $0.dateCompleted < endOfMonth })
        
    }
    
    func incrementHabit() {
        habit.addRecord()
    }
    
    func decrementHabit() {
        habit.removeLastRecordInCurrentInterval()
    }
}
