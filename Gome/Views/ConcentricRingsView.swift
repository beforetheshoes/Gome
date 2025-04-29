//
//  ConcentricRingsView.swift
//  Gome
//
//  Created by Ryan Williams on 4/26/25.
//

import SwiftUI

struct ConcentricRingsView: View {
    let habit: Habit
    let ringWidth: CGFloat = 10
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var settings: UserSettings
    
    var separatorColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var body: some View {
        ZStack {
            // Outer: Month Ring
            RingView(
                settings: settings,
                slices: habit.monthRingData(),
                ringWidth: ringWidth,
                radius: 55,
                ringPosition: .outer
            )
            
            Circle()
                .stroke(separatorColor.opacity(0.3), lineWidth: 1)
                .frame(width: 110, height: 110)
            
            // Middle: Week Ring (always 7 slices)
            RingView(
                settings: settings,
                slices: weekRingData(),
                ringWidth: ringWidth,
                radius: 45,
                ringPosition: .middle
            )
            
            Circle()
                .stroke(separatorColor.opacity(0.3), lineWidth: 1)
                .frame(width: 90, height: 90)
            
            // Inner: Day Ring (progress based)
            ZStack {
                Circle()
                    .stroke(
                        .secondary.opacity(0.2), // light opacity for background
                        lineWidth: ringWidth
                    )
                    .frame(width: 60, height: 60)
                
                
                Circle()
                    .trim(from: 0, to: progressAmount)
                    .stroke(
                        settings.customInnerRing,
                        style: StrokeStyle(lineWidth: ringWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90)) // start at top
                    .frame(width: 60, height: 60)
                    .animation(.easeInOut(duration: 0.5), value: progressAmount)
            }
            
            Circle()
                .stroke(separatorColor.opacity(0.3), lineWidth: 1)
                .frame(width: 70, height: 70)
            // Center
            VStack {
                Text("\(intervalCompletions)/\(habit.goalThreshold)")
                    .font(.caption)
                    .bold()
                    .foregroundColor(habit.primaryGoalMet ? .black : .gray)
            }
            .frame(width: 45, height: 45)
            .background(habit.primaryGoalMet ? Color.green.opacity(0.9) : Color.secondary.opacity(0.1))
            .clipShape(Circle())
        }
    }
    
    func weekRingData() -> [Bool] {
        let calendar = Calendar.current
        let today = Date()
        guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else { return [] }
        
        return (0..<7).map { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek) else { return false }
            return habit.isGoalMet(for: date, interval: .day)
        }
    }
    
    var progressAmount: CGFloat {
        guard habit.goalThreshold > 0 else { return 0 }
        
        switch(habit.primaryInterval) {
        case .day:
            return min(CGFloat(habit.primaryCompletions) / CGFloat(habit.goalThreshold), 1)
        case .week, .month:
            // Calculate daily progress for weekly habit
            let completionsToday = habit.records.filter { Calendar.current.isDateInToday($0.dateCompleted) }.count
            let completionsPerDay = CGFloat(habit.goalThreshold) / 7.0 // Divide goal by 7 for daily comparison
            
            if Double(completionsToday) > completionsPerDay {
                return 1 // The daily ring is closed if more completions than required for the day
            } else {
                return Double(completionsToday) / completionsPerDay // Otherwise, fill the ring based on today's completions
            }
        }
    }
    
    var intervalCompletions: Int {
        let calendar = Calendar.current
        let today = Date()
        
        switch habit.primaryInterval {
        case .day:
            // Count completions for *today*
            return habit.records.filter { calendar.isDateInToday($0.dateCompleted) }.count
        case .week:
            // Count completions for *this week*
            guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: today)?.start else { return 0 }
            return habit.records.filter {
                $0.dateCompleted >= startOfWeek && $0.dateCompleted < calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
            }.count
        case .month:
            // Count completions for *this month*
            guard let startOfMonth = calendar.dateInterval(of: .month, for: today)?.start else { return 0 }
            return habit.records.filter {
                $0.dateCompleted >= startOfMonth && $0.dateCompleted < calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            }.count
        }
    }
}
