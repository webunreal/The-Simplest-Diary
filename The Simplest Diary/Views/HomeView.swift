//
//  HomeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var entries = Entries()
 
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    ForEach(entries.entriesList.reversed(), id: \.self) { entry in
                        NavigationLink(destination: SelectedEntryView(entry: self.$entries.entriesList[self.entries.entriesList.firstIndex(of: entry)!])) {
                            RowView(entry: entry)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }.onDelete(perform: { indexSet in
                        entries.entriesList.remove(atOffsets: indexSet)
                        print(indexSet)
                    })
                }
            }
            .padding()
            .navigationBarTitle("Entries")
            .navigationBarItems(leading:
                                    NavigationLink(destination: SettingsView()) {
                                        Image(systemName: "gear")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    },
                                trailing:
                                    NavigationLink(destination: AddNewEntryView(entries: $entries.entriesList)) {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                    })
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
        }
//        .environment(\.colorScheme, .dark)
    }
}

