//
//  TrashView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 26.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrashView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.filter({$0.isTrashed}).isEmpty {
                        LazyVStack {
                            ForEach(entries.filter({$0.isTrashed}).sorted(by: { $0.date! > $1.date! }), id: \.self) { entry in
                                if let index = entries.firstIndex(of: entry) {
                                    NavigationLink(destination: TrashedEntryView(index: index)) {
                                        HStack(spacing: 0) {
                                            ZStack {
                                                LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                    .cornerRadius(15)
                                                    .opacity(-Double(entry.offset) / 90)
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            deleteOneEntryFromTrash(index: index)
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
                                                        withAnimation(.easeIn) {
                                                            recoverOneEntryFromTrash(index: index)
                                                        }
                                                    }) {
                                                        Label("Recover", systemImage: "arrow.clockwise")
                                                    }
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            deleteOneEntryFromTrash(index: index)
                                                        }
                                                    }) {
                                                        Label("Delete", systemImage: "trash")
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
                        .navigationBarTitle("Trash")
                        .navigationBarItems(
                            leading:
                                Button(action: {
                                    withAnimation(.easeIn) {
                                        deleteAllEntriesFromTrash()
                                    }
                                }) {
                                    Text("Delete all")
                                        .foregroundColor(.red)
                                },
                            trailing:
                                Button(action: {
                                    withAnimation(.easeIn) {
                                        recoverAllEntriesFromTrash()
                                    }
                                }) {
                                    Text("Recover all")
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
            }
        }
    }
    
    private func recoverOneEntryFromTrash(index: Int) {
        entries[index].isTrashed = false
        saveContext()
    }
    
    private func deleteOneEntryFromTrash(index: Int) {
        self.managedObjectContext.delete(entries[index])
        saveContext()
    }
    
    private func deleteAllEntriesFromTrash() {
        for entry in entries where entry.isTrashed {
            self.managedObjectContext.delete(entry)
        }
        saveContext()
    }
    
    private func recoverAllEntriesFromTrash() {
        for entry in entries where entry.isTrashed {
            entry.isTrashed = false
        }
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
                    deleteOneEntryFromTrash(index: index)
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
struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
    }
}
