//
//  CompletionListView.swift
//  Gome
//
//  Created by Ryan Williams on 4/27/25.
//

import SwiftUI
import SwiftData

struct CompletionListView: View {
    @Environment(\.modelContext) private var modelContext
    var completions: [HabitRecord]
    
    @State private var searchText = ""
    @State private var recordPendingDeletion: HabitRecord?
    @State private var recordBeingEdited: HabitRecord?
    @State private var isEditingNote = false

    private var filteredCompletions: [HabitRecord] {
        let sorted = completions.sorted { $0.dateCompleted > $1.dateCompleted }
        if searchText.isEmpty {
            return sorted
        } else {
            return sorted.filter { formattedDate(for: $0.dateCompleted).localizedCaseInsensitiveContains(searchText) }
        }
    }

    private func formattedDate(for date: Date) -> String {
        dateFormatter.string(from: date)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private func timeFormatted(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private var groupedCompletions: [Date: [HabitRecord]] {
        Dictionary(grouping: filteredCompletions) { $0.dateCompleted.onlyDate }
    }
    
    private func completionRow(for completion: HabitRecord) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(timeFormatted(for: completion.dateCompleted))
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                if let note = completion.note, !note.isEmpty {
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
            NavigationStack {
                Group {
                    if filteredCompletions.isEmpty {
                        ContentUnavailableView(
                            "No Completions",
                            systemImage: "checkmark.circle",
                            description: Text("You haven't logged any completions yet.")
                        )
                        .padding()
                    } else {
                        List {
                            ForEach(groupedCompletions.keys.sorted(by: >), id: \.self) { date in
                                Section(header: Text(formattedDate(for: date))) {
                                    ForEach(groupedCompletions[date] ?? [], id: \.id) { completion in
                                        completionRow(for: completion)
                                        .contentShape(Rectangle()) // Makes the whole row swipeable
                                        .onTapGesture {
                                            recordBeingEdited = completion
                                            isEditingNote = true
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                recordPendingDeletion = completion
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .listStyle(.insetGrouped)
                    }
                }
                .navigationTitle("Completions")
                .searchable(text: $searchText, prompt: "Search dates")
                .confirmationDialog(
                    "Are you sure you want to delete this completion?",
                    isPresented: Binding(
                        get: { recordPendingDeletion != nil },
                        set: { newValue in
                            if !newValue { recordPendingDeletion = nil }
                        }
                    ),
                    titleVisibility: .visible
                ) {
                    Button("Delete", role: .destructive) {
                        if let record = recordPendingDeletion {
                            delete(record)
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
                .sheet(item: $recordBeingEdited) { record in
                    NoteEditorView(record: record)
                }
            }
        }
        
        private func delete(_ completion: HabitRecord) {
            withAnimation {
                modelContext.delete(completion)
                try? modelContext.save()
            }
        }
    }


private struct NoteEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var noteText: String
    var record: HabitRecord

    init(record: HabitRecord) {
        self.record = record
        _noteText = State(initialValue: record.note ?? "")
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $noteText)
                    .padding()
                    .frame(maxHeight: 300)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .padding()
                Spacer()
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        record.note = noteText
                        try? modelContext.save()
                        dismiss()
                    }
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
