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
                            ForEach(entries.entriesList.reversed(), id: \.id) { entry in
                                if let index = entries.entriesList.firstIndex(of: entry) {
                                    NavigationLink(destination:                           DetailedEntryView(index: index, onEdit: onEdit, entryText: entries.entriesList[index].text), tag: index, selection: $selectedEntry) {
                                        HStack(spacing: 0) {
                                            ZStack {
                                                LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
                                                    .cornerRadius(15)
                                                    .opacity(-Double(entry.offset) / 90)
                                                HStack {
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation(.easeIn) {
                                                            entries.moveTotrash(index: index)
                                                        }
                                                    }) {
                                                        Image(systemName: "trash")
                                                            .font(.title)
                                                            .foregroundColor(.white)
                                                            .frame(width: 90, height: 50)
                                                    }
                                                }
                                                .opacity(-Double(entry.offset) / 90)
                                                RowView(entry: entries.entriesList[index])
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
                                                            entries.moveTotrash(index: index)
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
                    }
                }
            }
        }
    }
    
    private func onChanged(value: DragGesture.Value, index: Int) {
        if value.translation.width < 0 {
            if entries.entriesList[index].isSwiped {
                entries.entriesList[index].offset = value.translation.width - 90
            } else {
                entries.entriesList[index].offset = value.translation.width
            }
        }
    }
    
    private func onEnded(value: DragGesture.Value, index: Int) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    entries.entriesList[index].offset = -1000
                    entries.moveTotrash(index: index)
                } else if -entries.entriesList[index].offset > 50 {
                    entries.entriesList[index].isSwiped = true
                    entries.entriesList[index].offset = -90
                } else {
                    entries.entriesList[index].isSwiped = false
                    entries.entriesList[index].offset = 0
                }
            } else {
                entries.entriesList[index].isSwiped = false
                entries.entriesList[index].offset = 0
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

