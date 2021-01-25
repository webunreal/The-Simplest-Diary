//
//  HomeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import CoreHaptics
@available(iOS 14.0, *)

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    @State private var searchText = ""
    @State private var showingSelection: Bool = false
    
    private let navigationBarImageSize: CGFloat = 25
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.filter({!$0.isTrashed}).isEmpty {
                        LazyVStack {
                            SearchBarView(searchText: $searchText)
                                .opacity(self.showingSelection ? 0 : 1)
                                .animation(.easeInOut)
                            ForEach(
                                entries.filter {
                                    guard let text = $0.text else { return false }
                                    return self.searchText.isEmpty ?
                                        !$0.isTrashed : !$0.isTrashed &&
                                        text.lowercased().contains(self.searchText.lowercased())
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
                                                    DetailedEntryView(entry: entry, entryText: entry.text ?? "Error")) {
                                        ZStack {
                                            LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                .cornerRadius(15)
                                                .opacity(-Double(entry.offset) / 90)
                                            HStack {
                                                Spacer()
                                                Button(action: {
                                                    withAnimation(.easeIn) {
                                                        moveToTrash(entry: entry)
                                                    }
                                                }) {
                                                    Image(systemName: "trash")
                                                        .font(.title)
                                                        .foregroundColor(.white)
                                                        .frame(width: 90, height: 50)
                                                }
                                            }
                                            .opacity(-Double(entry.offset) / 90)
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
                        .resignKeyboardOnDragGesture()
                        .padding(.horizontal)
                        .navigationBarTitle("Entries")
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
                                Button(action: {
                                    if self.showingSelection {
                                        withAnimation(.easeIn) {
                                            moveSelectedToTrash()
                                        }
                                        self.showingSelection = false
                                    }
                                }) {
                                    if self.showingSelection {
                                        Image(systemName: "trash")
                                            .resizable()
                                            .frame(width: navigationBarImageSize, height: navigationBarImageSize)
                                            .foregroundColor(checkAtLeastOneIsSelected() ? .red : .secondary)
                                    } else if self.searchText.isEmpty {
                                        NavigationLink(destination: AddNewEntryView()) {
                                            Image(systemName: "square.and.pencil")
                                                .resizable()
                                                .frame(width: navigationBarImageSize, height: navigationBarImageSize)
                                        }
                                    }
                                }
                                .animation(.easeInOut(duration: 0.2))
                                .disabled(self.showingSelection && !checkAtLeastOneIsSelected())
                        )
                    } else {
                        NoEntriesView()
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.height)
                            .navigationBarTitle("Entries")
                            .navigationBarItems(
                                trailing:
                                    NavigationLink(destination: AddNewEntryView()) {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: navigationBarImageSize, height: navigationBarImageSize)
                                    })
                    }
                }
                .fixFlickering()
                .gesture(DragGesture()
                            .onChanged({ _ in
                                UIApplication.shared.endEditing(true)
                                
                            }))
            }
        }
    }
    
    private func moveToTrash(entry: Entry) {
        entry.isTrashed = true
        entry.offset = 0
        entry.isSwiped = false
        entry.isSelected = false
        
        saveContext()
    }
    
    private func moveSelectedToTrash() {
        for entry in entries.filter({!$0.isTrashed}) where entry.isSelected {
            moveToTrash(entry: entry)
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
        for entry in entries.filter({!$0.isTrashed}) {
            if entry.isSelected {
                return true
            }
        }
        return false
    }
    
    private func swipeOnChanged(value: DragGesture.Value, entry: Entry) {
        if value.translation.width < 0 {
            if entry.isSwiped {
                entry.offset = Float(value.translation.width - 90)
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
                    moveToTrash(entry: entry)
                } else if -entry.offset > 50 {
                    entry.isSwiped = true
                    entry.offset = -90
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
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        //        .environment(\.colorScheme, .dark)
    }
}

