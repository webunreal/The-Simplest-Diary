//
//  CreatePasscodeView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 14.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import AudioToolbox

@available(iOS 14.0, *)
struct CreatePasscodeView: View {
    private let hStackSpacing: CGFloat = 20
    
    @AppStorage("passcode") private var passcode: String = ""
    @Environment(\.presentationMode) var presentation
    @Binding var isPasscodeUsed: Bool
    @State private var count: Int = 0
    @State private var firstEnteredPasscode: String = ""
    @State private var secondEnteredPasscode: String = ""
    @State private var isFirstFieldDotFilled = [Bool](repeating: false, count: 4)
    @State private var isSecondFieldDotFilled = [Bool](repeating: false, count: 4)
    @State private var isFirstFieldFilled: Bool = false
    @State private var isErrorTextShown: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    Spacer()
                    VStack {
                        if self.isErrorTextShown {
                            Text("Passcodes are not the same")
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }
                        Text("Create passcode")
                            .padding(.bottom, 20)
                        HStack {
                            ForEach(1..<5) { index in
                                DotView(isFilled: isFirstFieldDotFilled[index - 1])
                                    .animation(.spring())
                            }
                        }
                        .padding(.bottom, 20)
                            Text("Repeate passcode")
                                .padding(.bottom, 20)
                                .opacity(self.isFirstFieldFilled ? 1 : 0)
                                .animation(.spring())
                            
                            HStack {
                                ForEach(1..<5) { index in
                                    DotView(isFilled: isSecondFieldDotFilled[index - 1])
                                        .animation(.spring())
                                }
                            }
                            .opacity(self.isFirstFieldFilled ? 1 : 0)
                            .padding(.bottom, 50)
                    }
                    Spacer()
                    VStack(spacing: 5) {
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
                                
                            }) {
                                PasscodeButtonView(number: 0)
                                    .hidden()
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
                .onAppear(perform: disablePasscode)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                
            }
        }
    }
    
    private func disablePasscode() {
        self.isPasscodeUsed = false
    }
    
    private func buttonTapped(number: Int) {
        if isFirstFieldFilled {
            fillSecondField(number: number)
        } else {
            fillFirstField(number: number)
        }
    }
    
    private func fillFirstField(number: Int) {
        if self.count < 4 {
            self.isFirstFieldDotFilled[self.count].toggle()
            self.count += 1
            self.firstEnteredPasscode += String(number)
            
            if self.count == 4 {
                self.isFirstFieldFilled = true
                self.count = 0
            }
        }
    }
    
    private func fillSecondField(number: Int) {
        if self.count < 4 {
            self.isSecondFieldDotFilled[self.count].toggle()
            self.count += 1
            self.secondEnteredPasscode += String(number)
            
            if self.count == 4 {
                checkPasscodes()
            }
        }
    }
    
    private func deleteButton() {
        if self.isFirstFieldFilled {
            if self.count > 0 {
                self.count -= 1
                self.isSecondFieldDotFilled[self.count].toggle()
                self.secondEnteredPasscode = String(self.secondEnteredPasscode.dropLast())
                
                if self.count == 0 {
                    self.count = 4
                    self.isFirstFieldFilled = false
                }
            } else {
                self.count = 3
                self.isFirstFieldFilled = false
                self.isFirstFieldDotFilled[self.count].toggle()
                self.firstEnteredPasscode = String(self.firstEnteredPasscode.dropLast())
            }
        } else {
            if self.count > 0 {
                self.count -= 1
                self.isFirstFieldDotFilled[self.count].toggle()
                self.firstEnteredPasscode = String(self.firstEnteredPasscode.dropLast())
            }
        }
    }
    
    private func checkPasscodes() {
        if self.firstEnteredPasscode == self.secondEnteredPasscode {
            self.passcode = self.secondEnteredPasscode
            self.isPasscodeUsed = true
            self.presentation.wrappedValue.dismiss()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                withAnimation(.easeIn) {
                    self.isErrorTextShown = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeOut) {
                        self.isErrorTextShown = false
                    }
                }
                
                self.count = 0
                self.isFirstFieldFilled = false
                self.firstEnteredPasscode = ""
                self.secondEnteredPasscode = ""
                self.isFirstFieldDotFilled = [Bool](repeating: false, count: 4)
                self.isSecondFieldDotFilled = [Bool](repeating: false, count: 4)
            }
        }
    }
}

@available(iOS 14.0, *)
struct CreatePassCodeView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePasscodeView(isPasscodeUsed: .constant(false))
    }
}
