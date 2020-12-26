//
//  TabView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 24.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
@available(iOS 14.0, *)

struct AppTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("Entries")
                }
            
            TrashView()
                .tabItem {
                    Image(systemName: "trash")
                    Text("Trash")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

@available(iOS 14.0, *)
struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
