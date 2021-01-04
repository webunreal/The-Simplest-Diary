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
    @EnvironmentObject var entries: Entries
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical) {
                    if !entries.trashedEntriesList.isEmpty {
                        LazyVStack {
                            ForEach(entries.trashedEntriesList.reversed(), id: \.self) { entry in
                                if let index = entries.trashedEntriesList.firstIndex(of: entry) {
                                    NavigationLink(
                                        destination: TrashedEntryView(index: index)) {
                                        HStack {
                                            RowView(entry: entries.trashedEntriesList[index])
                                            Button(action: {
                                            }, label: {
                                                Menu {
                                                    Button(action: {
                                                        entries.recoverOneEntryFromTrash(index: index)
                                                    }) {
                                                        Label("Recover", systemImage: "arrow.clockwise")
                                                    }
                                                    Button(action: {
                                                        entries.deleteOneEntryFromTrash(index: index)
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
                                    entries.deleteAllEntriesFromTrash()
                                }) {
                                    Text("Delete all")
                                        .foregroundColor(.red)
                                },
                            trailing:
                                Button(action: {
                                    entries.recoverAllEntriesFromTrash()
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
}


@available(iOS 14.0, *)
struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
    }
}
