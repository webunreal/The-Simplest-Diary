//
//  SettingsView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 11.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import LocalAuthentication

@available(iOS 14.0, *)
struct SettingsView: View {
    @State private var showCreatePasscodeView: Bool = false
    @AppStorage("isPasscodeUsed") private var isPasscodeUsed: Bool = false
    @AppStorage("isBiometricUsed") private var isBiometricUsed: Bool = false
    @AppStorage("passcode") private var passcode: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: CreatePasscodeView(isPasscodeUsed: $isPasscodeUsed), isActive: $showCreatePasscodeView) {}.hidden()
                Form {
                    Section(header: Text("Passcode")) {
                        Toggle(isOn: $isPasscodeUsed) {
                            Text("Use Passcode")
                        }
                        .onChange(of: isPasscodeUsed, perform: { value in
                            if value {
                                self.showCreatePasscodeView = true
                            } else {
                                self.passcode = ""
                                self.isBiometricUsed = false
                            }
                        })
                        
                        if Biometric.biometricType != .none && self.isPasscodeUsed && !self.passcode.isEmpty {
                            Toggle(isOn: $isBiometricUsed) {
                                Text("Use " + Biometric.biometricTypeName)
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

@available(iOS 14.0, *)
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
