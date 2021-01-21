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
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.filter({!$0.isTrashed}).isEmpty {
                        LazyVStack {
                            SearchBarView(searchText: $searchText)
                            ForEach(
                                entries.filter {
                                    guard let text = $0.text else { return false }
                                    return self.searchText.isEmpty ?
                                        !$0.isTrashed : !$0.isTrashed &&
                                        text.lowercased().contains(self.searchText.lowercased())
                                }.sorted(by: { guard let date1 = $0.date, let date2 = $1.date else { return false }
                                    return date1 > date2
                                }), id: \.self) { entry in
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
                        .resignKeyboardOnDragGesture()
                        .padding(.horizontal)
                        .navigationBarTitle("Entries")
                        .navigationBarItems(
                            trailing:
                                NavigationLink(destination: AddNewEntryView()) {
                                    Image(systemName: "square.and.pencil")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                })
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
                                            .frame(width: 25, height: 25)
                                    })
                    }
                }
                .fixFlickering()
                .onTapGesture {
                    UIApplication.shared.endEditing(true)
                }
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
        
        saveContext()
    }
    
    private func saveContext() {
        haptic.impactOccurred()
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
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

