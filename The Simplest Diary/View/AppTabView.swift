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
    @State var isLogged: Bool = !UserDefaults.standard.bool(forKey: "isPasscodeUsed")
    
    var body: some View {
        if isLogged {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "pencil")
                        Text("Entries")
                    }
                
                PinnedView()
                    .tabItem {
                        Image(systemName: "pin.fill")
                        Text("Pinned")
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
        } else {
            PasscodeView(isPasscodeCorrect: $isLogged)
        }
    }
}

@available(iOS 14.0, *)
struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        //        AppTabView()
        EmptyView()
    }
}
