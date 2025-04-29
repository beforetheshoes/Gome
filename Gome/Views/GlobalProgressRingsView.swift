//
//  GlobalRingsView.swift
//  Gome
//
//  Created by Ryan Williams on 4/27/25.
//

import SwiftUI


struct GlobalProgressRingsView: View {
    let habits: [Habit]
    let ringWidth: CGFloat = 8
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Outer Ring: Month
                Circle()
                    .trim(from: 0, to: allHabitsOnTrack(for: GoalInterval.month) ? 1 : 0)
                    .stroke(
                        Color(hex: 0x36a4f5),
                        style: StrokeStyle(lineWidth: ringWidth)
                    )
                    .frame(width: geo.size.width - 20, height: geo.size.height - 20)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: allHabitsOnTrack(for: GoalInterval.month))
                
                // Middle Ring: Week
                Circle()
                    .trim(from: 0, to: allHabitsOnTrack(for: GoalInterval.week) ? 1 : 0)
                    .stroke(
                        Color(hex: 0x8ecae6),
                        style: StrokeStyle(lineWidth: ringWidth)
                    )
                    .frame(width: geo.size.width - 50, height: geo.size.height - 50)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: allHabitsOnTrack(for: GoalInterval.week))
                
                // Inner Ring: Day
                Circle()
                    .trim(from: 0, to: allHabitsOnTrack(for: GoalInterval.day) ? 1 : 0)
                    .stroke(
                        Color(hex: 0xd528fe),
                        style: StrokeStyle(lineWidth: ringWidth)
                    )
                    .frame(width: geo.size.width - 80, height: geo.size.height - 80)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: allHabitsOnTrack(for: GoalInterval.day))
            }
        }
        .ignoresSafeArea()
    }
    
    private func allHabitsOnTrack(for interval: GoalInterval) -> Bool {
        let result = habits.allSatisfy { habit in
            let met = habit.isGoalMet(for: Date(), interval: interval)
            print("Habit \(habit.name) goal met for \(interval): \(met)")
            return met
        }
        print("All habits on track for \(interval): \(result)")
        return result
    }
}
