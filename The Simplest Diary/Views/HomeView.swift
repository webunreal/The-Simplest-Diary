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
//    @Environment var entries: Entries
    @ObservedObject var entries = Entries()
    @State private var showingSelectedEntryView = false
    @State private var onEdit = false
    
    var body: some View {
        NavigationView {
            if !entries.entriesList.isEmpty {
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(entries.entriesList.reversed(), id: \.self) { entry in
                            NavigationLink(
                                destination: SelectedEntryView(entry: self.$entries.entriesList[self.entries.entriesList.firstIndex(of: entry)!], onEdit: onEdit, entryText: entry.text), isActive: self.$showingSelectedEntryView) {
                                HStack {
                                    RowView(entry: entry)
                                    Button(action: {
                                    }, label: {
                                        Menu {
                                            Button(action: {
                                                self.onEdit = true
                                                self.showingSelectedEntryView = true
                                            }) {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            
                                            Button(action: {
                                                let index = entries.entriesList.firstIndex(of: entry)
                                                entries.moveTotrash(entry: entry, index: index!)
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        label: {
                                            Image(systemName: "ellipsis.circle")
                                                .foregroundColor(Color("menuColor"))
                                        }
                                    })
                                }
                                
                            }.padding(.bottom, 1)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .navigationBarTitle("Entries")
                    .navigationBarItems(
                        trailing:
                            NavigationLink(destination: AddNewEntryView(entries: $entries.entriesList)) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            })
                }
            } else {
                Text("There are no entries")
            }
        }
    }
}

@available(iOS 14.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()

        }
//        .environment(\.colorScheme, .dark)
    }
}

