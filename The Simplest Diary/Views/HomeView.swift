//
//  HomeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    var entries = entriesList
    
    init() {
       UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
        
        NavigationView {
            List(entries, id: \.date) { entry in
                RowView(entry: entry)
                NavigationLink(destination: EntryView(entry: entry.text)) {
                    EmptyView()
                }.hidden().frame(width: 0)
                
            }
                .navigationBarTitle("Entries")
                .navigationBarHidden(false)
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        .environment(\.colorScheme, .dark)
    }
}

