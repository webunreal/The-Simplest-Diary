//
//  PasscodeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 13.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import AudioToolbox
import LocalAuthentication

@available(iOS 14.0, *)
struct PasscodeView: View {
    private let hStackSpacing: CGFloat = 30
    
    @State private var count: Int = 0
    @State private var isDotFilled = [Bool](repeating: false, count: 4)
    @State private var enteredPasscode: String = ""
    @AppStorage("passcode") private var passcode: String = ""
    @AppStorage("isFaceIDUsed") private var isFaceIDUsed: Bool = false
    @Binding var isPasscodeCorrect: Bool
    
    private let isFaceIDAvaliadle: Bool =  {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                    HStack {
                        ForEach(1..<5) { index in
                            DotView(isFilled: isDotFilled[index - 1])
                                .animation(.spring())
                        }
                    }
                    Spacer()
                    VStack(spacing: 10) {
                        HStack(spacing: hStackSpacing) {
                            ForEach(1..<4) { number in
                                Button(action: {
                                    buttonTapped(number: number)
                                }) {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            ForEach(4..<7) { number in
                                Button(action: {
                                    buttonTapped(number: number)
                                }) {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            ForEach(7..<10) { number in
                                Button(action: {
                                    buttonTapped(number: number)
                                }) {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            Button(action: {
                                if (self.isFaceIDAvaliadle && self.isFaceIDUsed) {
                                    authenticate()
                                }
                            }) {
                                Image(systemName: "faceid")
                                    .font(.system(size: 40))
                                    .foregroundColor(.primary)
                                    .frame(width: 80, height: 80)
                                    .opacity((self.isFaceIDAvaliadle && self.isFaceIDUsed) ? 1 : 0)
                            }
                            Button(action: {
                                buttonTapped(number: 0)
                            }) {
                                PasscodeButtonView(number: 0)
                            }
                            Button(action: {
                                deleteButton()
                            }) {
                                Image(systemName: "delete.left")
                                    .font(.system(size: 40))
                                    .foregroundColor(.primary)
                                    .frame(width: 80, height: 80)
                            }
                        }
                        .padding(.bottom, hStackSpacing)
                    }
                }
                .onAppear(perform: authenticate)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
        }
    }
    
    private func buttonTapped(number: Int) {
        if self.count < 4 {
            self.isDotFilled[self.count].toggle()
            self.count += 1
            self.enteredPasscode += String(number)
            if self.count == 4 {
                checkPasscode()
            }
        }
    }
    
    private func deleteButton() {
        if self.count > 0 {
            self.count -= 1
            self.isDotFilled[self.count].toggle()
            self.enteredPasscode = String(self.enteredPasscode.dropLast())
        }
    }
    
    private func checkPasscode() {
        if self.enteredPasscode == self.passcode {
            self.isPasscodeCorrect = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                self.count = 0
                self.isDotFilled = [Bool](repeating: false, count: 4)
                self.enteredPasscode = ""
            }
            
        }
    }
    
    private func authenticate() {
        if !self.isFaceIDUsed {
            return
        } else {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Unlock the app"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            self.isDotFilled = [true, true, true, true]
                            self.isPasscodeCorrect = true
                        } else {
                            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        }
                    }
                }
            } else {
                return
            }
        }
    }
    
}

@available(iOS 14.0, *)
struct PassCodeView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeView(isPasscodeCorrect: .constant(false))
    }
}
