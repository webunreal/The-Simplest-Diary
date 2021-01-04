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
    @EnvironmentObject var entries: Entries
    @State var selectedEntry: Int?
    @State private var onEdit = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.entriesList.isEmpty {
                        LazyVStack {
                            ForEach(entries.entriesList.reversed(), id: \.self) { entry in
                                if let index = entries.entriesList.firstIndex(of: entry) {
                                    NavigationLink(destination:                           DetailedEntryView(index: index, onEdit: onEdit, entryText: entries.entriesList[index].text), tag: index, selection: $selectedEntry) {
                                        HStack {
                                            RowView(entry: entries.entriesList[index])
                                            Button(action: {}, label: {
                                                Menu {
                                                    Button(action: {
                                                        self.onEdit = true
                                                        selectedEntry = index
                                                    }) {
                                                        Label("Edit", systemImage: "pencil")
                                                    }
                                                    Button(action: {
                                                        entries.moveTotrash(index: index)
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
                    }
                }
            }
        }
    }
    
//    private func getIndex(entry: Entry) -> Int {
//        return entries.entriesList.firstIndex { (item1) -> Bool in
//            return entry.id == item1.id
//        } ?? 0
//    }
}


@available(iOS 14.0, *)
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        //        .environment(\.colorScheme, .dark)
    }
}

