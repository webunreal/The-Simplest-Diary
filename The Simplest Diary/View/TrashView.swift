//
//  TrashView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 26.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import CoreHaptics

@available(iOS 14.0, *)
struct TrashView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    @State private var showDeletingAlert: Bool = false
    @State private var showAlertDeleteSelectedEntries: Bool = false
    @State private var showAlertDeleteOneEntry: Bool = false
    @State private var deletingEntry: Entry? = nil
    @State private var showingSelection: Bool = false
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.filter({$0.isTrashed}).isEmpty {
                        LazyVStack {
                            ForEach(entries.filter {
                                $0.isTrashed
                            }.sorted(by: { guard let date1 = $0.date, let date2 = $1.date else { return false }
                                return date1 > date2
                            }), id: \.self) { entry in
                                if self.showingSelection {
                                    HStack {
                                        Button(action: {
                                            entry.isSelected.toggle()
                                        }) {
                                            SelectionView(isFilled: entry.isSelected)
                                        }
                                        .frame(width: 30, height: 80)
                                        
                                        RowView(date: entry.date ?? Date(), text: entry.text ?? "Error")
                                    }
                                } else {
                                    NavigationLink(destination:
                                                    TrashedEntryView(entry: entry)) {
                                        ZStack {
                                            LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                .cornerRadius(15)
                                                .opacity(-Double(entry.offset) / 180)
                                            HStack(spacing: 0) {
                                                Spacer()
                                                ZStack {
                                                    LinearGradient(gradient: .init(colors: [Color(.clear), Color(.blue)]), startPoint: .leading, endPoint: .trailing)
                                                        .cornerRadius(15)
                                                    HStack(spacing: 0) {
                                                        Spacer()
                                                        Button(action: {
                                                            withAnimation(.easeIn) {
                                                                recoverOneEntryFromTrash(entry: entry)
                                                            }
                                                        }) {
                                                            Image(systemName: "arrow.clockwise")
                                                                .font(.title)
                                                                .foregroundColor(.white)
                                                                .frame(width: 90, height: 80)
                                                        }
                                                    }
                                                }
                                                Button(action: {
                                                    self.deletingEntry = entry
                                                    self.showAlertDeleteOneEntry = true
                                                }) {
                                                    Image(systemName: "trash")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .frame(width: 90, height: 80)
                                                }
                                                .alert(isPresented: $showAlertDeleteOneEntry) {
                                                    Alert(title: Text("Delete this entry?"), primaryButton: .destructive(Text("Yes"), action: {
                                                        if let entry = deletingEntry {
                                                            deleteOneEntryFromTrash(entry: entry)
                                                        }
                                                    }), secondaryButton: .cancel())
                                                }
                                            }
                                            .opacity(-Double(entry.offset) / 180)
                                            RowView(date: entry.date ?? Date(), text: entry.text ?? "Error")
                                                .contentShape(Rectangle())
                                                .offset(x: CGFloat(entry.offset))
                                                .gesture(DragGesture()
                                                            .onChanged({ value in
                                                                swipeOnChanged(value: value, entry: entry)
                                                            })
                                                            .onEnded({value in
                                                                swipeOnEnded(value: value, entry: entry)
                                                            })
                                                )
                                        }
                                    }
                                    .padding(.bottom, 1)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarTitle("Trash")
                        .navigationBarItems(
                            leading:
                                Button(action: {
                                    self.showingSelection.toggle()
                                    for entry in entries {
                                        entry.isSelected = false
                                    }
                                }) {
                                    Text("Select")
                                        .font(.title3)
                                },
                            trailing:
                                Menu {
                                    Button(action: {
                                        withAnimation(.easeIn) {
                                            self.showingSelection ?
                                                recoverSelectedEntries() :
                                                recoverAllEntriesFromTrash()
                                        }
                                        self.showingSelection = false
                                    }) {
                                        Label(self.showingSelection ? "Recover" : "Recover all",
                                              systemImage: "arrow.clockwise")
                                    }
                                    .disabled(self.showingSelection && !checkAtLeastOneIsSelected())
                                    
                                    Button(action: {
                                        self.showDeletingAlert = true
                                    }) {
                                        Label(self.showingSelection ? "Delete" : "Delete all",
                                              systemImage: "trash")
                                    }
                                    .foregroundColor(.red)
                                    .disabled(self.showingSelection && !checkAtLeastOneIsSelected())
                                } label: {
                                    Image(systemName: "ellipsis.circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                                .alert(isPresented: $showDeletingAlert) {
                                    Alert(title:
                                            self.showingSelection ?
                                            Text("Delete selected entries from Trash?") :
                                            Text("Delete all entries from Trash?"), primaryButton: .destructive(Text("Yes"), action: {
                                                self.showingSelection ?
                                                    deleteSelectedEntries() :
                                                    deleteAllEntriesFromTrash()
                                                self.showingSelection = false
                                            }), secondaryButton: .cancel())
                                }
                        )
                    } else {
                        NoEntriesView()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                            .navigationBarTitle("Trash")
                            .navigationBarItems(
                                leading:
                                    EmptyView(),
                                trailing:
                                    EmptyView()
                            )
                    }
                }
                .fixFlickering()
            }
        }
    }
    
    private func recoverOneEntryFromTrash(entry: Entry) {
        entry.isTrashed = false
        entry.offset = 0
        entry.isSwiped = false
        entry.isSelected = false
        
        saveContext()
    }
    
    private func deleteOneEntryFromTrash(entry : Entry) {
        self.managedObjectContext.delete(entry)
        
        saveContext()
    }
    
    private func deleteAllEntriesFromTrash() {
        for entry in entries.filter({$0.isTrashed}) {
            deleteOneEntryFromTrash(entry: entry)
        }
    }
    
    private func recoverAllEntriesFromTrash() {
        for entry in entries.filter({$0.isTrashed}) {
            recoverOneEntryFromTrash(entry: entry)
        }
    }
    
    private func deleteSelectedEntries() {
        for entry in entries.filter({$0.isTrashed}) where entry.isSelected {
            deleteOneEntryFromTrash(entry: entry)
        }
    }
    
    private func recoverSelectedEntries() {
        for entry in entries.filter({$0.isTrashed}) where entry.isSelected {
            recoverOneEntryFromTrash(entry: entry)
        }
    }
    
    private func saveContext() {
        haptic.impactOccurred()
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func checkAtLeastOneIsSelected() -> Bool {
        for entry in entries.filter({$0.isTrashed}) {
            if entry.isSelected {
                return true
            }
        }
        return false
    }
    
    private func swipeOnChanged(value: DragGesture.Value, entry: Entry) {
        if value.translation.width < 0 {
            if entry.isSwiped {
                entry.offset = Float(value.translation.width - 180)
            } else {
                entry.offset = Float(value.translation.width)
            }
        }
    }
    
    private func swipeOnEnded(value: DragGesture.Value, entry: Entry) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    entry.offset = -1000
                    self.deletingEntry = entry
                    self.showAlertDeleteOneEntry = true
                    entry.offset = 0
                } else if -entry.offset > 50 {
                    entry.isSwiped = true
                    entry.offset = -180
                } else {
                    entry.isSwiped = false
                    entry.offset = 0
                }
            } else {
                entry.isSwiped = false
                entry.offset = 0
            }
        }
    }
}

@available(iOS 14.0, *)
struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
    }
}
