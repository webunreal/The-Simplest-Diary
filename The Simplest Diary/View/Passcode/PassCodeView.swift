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
    
    @State private var counter: Int = 0
    @State private var isDotFilled = [Bool](repeating: false, count: 4)
    @State private var enteredPasscode: String = ""
    @AppStorage("passcode") private var passcode: String = ""
    @AppStorage("isBiometricUsed") private var isBiometricUsed: Bool = false
    @Binding var isPasscodeCorrect: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                    Text("Enter passcode")
                        .padding(.bottom, 20)
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
                                Button {
                                    buttonTapped(number: number)
                                } label: {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            ForEach(4..<7) { number in
                                Button {
                                    buttonTapped(number: number)
                                } label: {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            ForEach(7..<10) { number in
                                Button {
                                    buttonTapped(number: number)
                                } label: {
                                    PasscodeButtonView(number: number)
                                }
                            }
                        }
                        HStack(spacing: hStackSpacing) {
                            Button {
                                if Biometric.biometricType != .none && isBiometricUsed {
                                    authenticate()
                                }
                            } label: {
                                Image(systemName: Biometric.biometricImageName)
                                    .font(.system(size: 40))
                                    .foregroundColor(.primary)
                                    .frame(width: 80, height: 80)
                                    .opacity((Biometric.biometricType != .none && isBiometricUsed) ? 1 : 0)
                            }
                            Button {
                                buttonTapped(number: 0)
                            } label: {
                                PasscodeButtonView(number: 0)
                            }
                            Button {
                                deleteButton()
                            } label: {
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
        if counter < 4 {
            isDotFilled[counter].toggle()
            counter += 1
            enteredPasscode += String(number)
            if counter == 4 {
                checkPasscode()
            }
        }
    }
    
    private func deleteButton() {
        if counter > 0 {
            counter -= 1
            isDotFilled[counter].toggle()
            enteredPasscode = String(enteredPasscode.dropLast())
        }
    }
    
    private func checkPasscode() {
        if enteredPasscode == passcode {
            isPasscodeCorrect = true
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                counter = 0
                isDotFilled = [Bool](repeating: false, count: 4)
                enteredPasscode = ""
            }
            
        }
    }
    
    private func authenticate() {
        if !isBiometricUsed {
            return
        } else {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Unlock the app"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                    DispatchQueue.main.async {
                        if success {
                            isDotFilled = [Bool](repeating: true, count: 4)
                            isPasscodeCorrect = true
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
