//
//  PageView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 04.03.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import CoreHaptics

@available(iOS 14.0, *)

struct PageView: View {
    public let page: Page
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var fetchedEntries: FetchedResults<Entry>
    @State private var searchText = ""
    @State private var showingSelection: Bool = false
    
    @State private var showDeletingAlert: Bool = false
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    private var entries: [Entry] {
        switch page {
        case .home:
            return fetchedEntries.filter { !$0.isTrashed }.sorted { guard let date1 = $0.date, let date2 = $1.date else { return false }
                return date1 > date2 }
        case.trash:
            return fetchedEntries.filter { $0.isTrashed }.sorted { guard let date1 = $0.date, let date2 = $1.date else { return false }
                return  date1 > date2 }
        }
    }
    
    private var navigationBarTitle: String {
        switch page {
        case .home:
            return "Entries"
        case.trash:
            return "Trash"
        }
    }
    
    private var columns: [GridItem]  {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
        } else {
            return [GridItem(.flexible())]
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    // MARK: - SearchBarView
                    if !entries.isEmpty {
                        SearchBarView(searchText: $searchText)
                            .opacity(self.showingSelection ? 0 : 1)
                            .animation(.easeInOut)
                        // MARK: - LazyVGrid
                        LazyVGrid(columns: columns) {
                            ForEach(
                                entries.filter {
                                    guard let text = $0.text else { return false }
                                    
                                    return self.searchText.isEmpty ?
                                        true : text.lowercased().contains(self.searchText.lowercased())
                                },
                                id: \.self) { entry in
                                //MARK: - Content
                                switch page {
                                case .home:
                                    NavigationLink(
                                        destination: DetailedEntryView(entry: entry, entryText: entry.text ?? "Error")
                                    ) {
                                        RowView(entry: entry, showingSelection: $showingSelection, page: page)
                                    }
                                    .padding(.bottom, 1)
                                    .buttonStyle(PlainButtonStyle())
                                case .trash:
                                    NavigationLink(
                                        destination:
                                            TrashedEntryView(entry: entry)
                                    ) {
                                        RowView(entry: entry, showingSelection: $showingSelection, page: page)
                                    }
                                    .padding(.bottom, 1)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .navigationBarTitle(navigationBarTitle)
                        //MARK: - Navigation Bar Items
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button {
                                    showingSelection.toggle()
                                    entries.forEach { $0.isSelected = false }
                                } label: {
                                    Text(showingSelection ?
                                            "Done" :
                                            "Select")
                                        .font(.title3)
                                }
                            }
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EmptyView()
                                switch page {
                                case .home:
                                    if showingSelection {
                                        Button {
                                            moveSelectedToTrash()
                                            showingSelection = false
                                        } label: {
                                            Image(systemName: "trash")
                                        }
                                        .disabled(!checkAtLeastOneIsSelected())
                                    } else  {
                                        NavigationLink(destination: AddNewEntryView()) {
                                            Image(systemName: "square.and.pencil")   
                                        }
                                        .disabled(!searchText.isEmpty)
                                    }
                                case .trash:
                                    Menu {
                                        Button {
                                            withAnimation(.easeIn) {
                                                showingSelection ?
                                                    recoverSelectedEntries() :
                                                    recoverAllEntriesFromTrash()
                                            }
                                            showingSelection = false
                                        } label: {
                                            Label(showingSelection ? "Recover" : "Recover all",
                                                  systemImage: "arrow.clockwise")
                                        }
                                        .disabled(showingSelection && !checkAtLeastOneIsSelected())
                                        
                                        Button {
                                            showDeletingAlert = true
                                        } label: {
                                            Label(showingSelection ? "Delete" : "Delete all",
                                                  systemImage: "trash")
                                        }
                                        .disabled(showingSelection && !checkAtLeastOneIsSelected())
                                    } label: {
                                        Image(systemName: "ellipsis.circle")
                                            .disabled(showingSelection && !checkAtLeastOneIsSelected())
                                    }
                                }
                            }
                        }
                        .alert(isPresented: $showDeletingAlert) {
                            Alert(
                                title:
                                    showingSelection ?
                                    Text("Delete selected entries from Trash?") :
                                    Text("Delete all entries from Trash?"), primaryButton: .destructive(Text("Yes"), action: {
                                        showingSelection ?
                                            deleteSelectedEntries() :
                                            deleteAllEntriesFromTrash()
                                        showingSelection = false
                                    }),
                                secondaryButton: .cancel() { showingSelection = false }
                            )
                        }
                    } else {
                        // MARK: - If there is no entry
                        NoEntriesView()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                            .navigationBarTitle(navigationBarTitle)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarLeading) {
                                    EmptyView()
                                }
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    switch page {
                                    case .home:
                                        NavigationLink(destination: AddNewEntryView()) {
                                            Image(systemName: "square.and.pencil")
                                        }
                                    case .trash:
                                        EmptyView()
                                    }
                                }
                            }
                    }
                }
                .fixFlickering()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - Moving to Trash
    public func moveSelectedToTrash() {
        for entry in entries where entry.isSelected {
            entry.isTrashed = true
        }
        saveContext()
    }
    
    //MARK: - Deleting
    private func deleteSelectedEntries() {
        for entry in entries where entry.isSelected {
            self.managedObjectContext.delete(entry)
        }
        saveContext()
    }
    
    private func deleteAllEntriesFromTrash() {
        for entry in entries {
            self.managedObjectContext.delete(entry)
        }
        saveContext()
    }
    
    //MARK: - Recovering
    private func recoverSelectedEntries() {
        for entry in entries where entry.isSelected {
            entry.isTrashed = false
        }
        saveContext()
    }
    
    private func recoverAllEntriesFromTrash() {
        for entry in entries {
            entry.isTrashed = false
        }
        saveContext()
    }
    
    //MARK: - Cheking Selection
    private func checkAtLeastOneIsSelected() -> Bool {
        for entry in entries {
            if entry.isSelected {
                return true
            }
        }
        return false
    }
    
    //MARK: - Saving Context
    private func saveContext() {
        haptic.impactOccurred()
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}
