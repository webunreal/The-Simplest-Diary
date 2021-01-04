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
                            ForEach(entries.trashedEntriesList.reversed(), id: \.id) { entry in
                                if let index = entries.trashedEntriesList.firstIndex(of: entry) {
                                    NavigationLink(
                                        destination: TrashedEntryView(index: index)) {
                                        HStack(spacing: 0) {
                                            ZStack {
                                                LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                    .cornerRadius(15)
                                                    .opacity(-Double(entry.offset) / 90)
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            entries.deleteOneEntryFromTrash(index: index)
                                                        }
                                                    }) {
                                                        Image(systemName: "trash")
                                                            .font(.title)
                                                            .foregroundColor(.white)
                                                            .frame(width: 90, height: 50)
                                                    }
                                                }
                                                .opacity(-Double(entry.offset) / 90)
                                                RowView(entry: entries.trashedEntriesList[index])
                                                    .contentShape(Rectangle())
                                                    .offset(x: entry.offset)
                                                    .gesture(DragGesture()
                                                                .onChanged({ value in
                                                                    onChanged(value: value, index: index)
                                                                })
                                                                .onEnded({value in
                                                                    onEnded(value: value, index: index)
                                                                })
                                                    )
                                            }
                                            Button(action: {
                                            }, label: {
                                                Menu {
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            entries.recoverOneEntryFromTrash(index: index)
                                                        }
                                                    }) {
                                                        Label("Recover", systemImage: "arrow.clockwise")
                                                    }
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            entries.deleteOneEntryFromTrash(index: index)
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
                                        entries.deleteAllEntriesFromTrash()
                                    }
                                }) {
                                    Text("Delete all")
                                        .foregroundColor(.red)
                                },
                            trailing:
                                Button(action: {
                                    withAnimation(.easeIn) {
                                        entries.recoverAllEntriesFromTrash()
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
    
    private func onChanged(value: DragGesture.Value, index: Int) {
        if value.translation.width < 0 {
            if entries.trashedEntriesList[index].isSwiped {
                entries.trashedEntriesList[index].offset = value.translation.width - 90
            } else {
                entries.trashedEntriesList[index].offset = value.translation.width
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value, index: Int) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    entries.trashedEntriesList[index].offset = -1000
                    entries.deleteOneEntryFromTrash(index: index)
                } else if -entries.trashedEntriesList[index].offset > 50 {
                    entries.trashedEntriesList[index].isSwiped = true
                    entries.trashedEntriesList[index].offset = -90
                } else {
                    entries.trashedEntriesList[index].isSwiped = false
                    entries.trashedEntriesList[index].offset = 0
                }
            } else {
                entries.trashedEntriesList[index].isSwiped = false
                entries.trashedEntriesList[index].offset = 0
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
