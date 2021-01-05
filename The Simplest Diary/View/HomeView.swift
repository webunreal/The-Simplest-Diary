//
//  HomeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
@available(iOS 14.0, *)

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    
    @State var selectedEntry: Int?
    @State private var onEdit = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.filter({!$0.isTrashed}).isEmpty {
                        LazyVStack {
                            ForEach(entries.filter({!$0.isTrashed}).sorted(by: { $0.date! > $1.date! }), id: \.self) { entry in
                                if let index = entries.firstIndex(of: entry) {
                                    NavigationLink(destination:                           DetailedEntryView(index: index, onEdit: onEdit, entryText: entries[index].text ?? "error"), tag: index, selection: $selectedEntry) {
                                        HStack(spacing: 0) {
                                            ZStack {
                                                LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                    .cornerRadius(15)
                                                    .opacity(-Double(entry.offset) / 90)
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            moveToTrash(index: index)
                                                        }
                                                    }) {
                                                        Image(systemName: "trash")
                                                            .font(.title)
                                                            .foregroundColor(.white)
                                                            .frame(width: 90, height: 50)
                                                    }
                                                }
                                                .opacity(-Double(entry.offset) / 90)
                                                RowView(entry: entries[index])
                                                    .contentShape(Rectangle())
                                                    .offset(x: CGFloat(entry.offset))
                                                    .gesture(DragGesture()
                                                                .onChanged({ value in
                                                                    onChanged(value: value, index: index)
                                                                })
                                                                .onEnded({value in
                                                                    onEnded(value: value, index: index)
                                                                })
                                                    )
                                            }
                                            Button(action: {}, label: {
                                                Menu {
                                                    Button(action: {
                                                        self.onEdit = true
                                                        selectedEntry = index
                                                    }) {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            moveToTrash(index: index)
                                                        }
                                                    }) {
                                                        Label("Move to Trash", systemImage: "trash")
                                                    }
                                                }
                                                label: {
                                                    MenuButtonView()
                                                }
                                            })
                                        }
                                    }
                                    .padding(.bottom, 1)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding()
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
            }
        }
    }
    
    private func moveToTrash(index: Int) {
        entries[index].isTrashed = true
        entries[index].offset = 0
        saveContext()
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func onChanged(value: DragGesture.Value, index: Int) {
        if value.translation.width < 0 {
            if entries[index].isSwiped {
                entries[index].offset = Float(value.translation.width - 90)
            } else {
                entries[index].offset = Float(value.translation.width)
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value, index: Int) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    entries[index].offset = -1000
                    moveToTrash(index: index)
                } else if -entries[index].offset > 50 {
                    entries[index].isSwiped = true
                    entries[index].offset = -90
                } else {
                    entries[index].isSwiped = false
                    entries[index].offset = 0
                }
            } else {
                entries[index].isSwiped = false
                entries[index].offset = 0
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

