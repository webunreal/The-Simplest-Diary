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
    @State private var counter: Int = 0
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
                    VStack {
                        if isErrorTextShown {
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
                            .opacity(isFirstFieldFilled ? 1 : 0)
                            .animation(.spring())
                        
                        HStack {
                            ForEach(1..<5) { index in
                                DotView(isFilled: isSecondFieldDotFilled[index - 1])
                                    .animation(.spring())
                            }
                        }
                        .opacity(isFirstFieldFilled ? 1 : 0)
                        .padding(.bottom, 5)
                    }
                    Spacer()
                    VStack(spacing: 5) {
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
                                
                            } label: {
                                PasscodeButtonView(number: 0)
                                    .hidden()
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
                .onAppear(perform: disablePasscode)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
                
            }
        }
    }
    
    private func disablePasscode() {
        isPasscodeUsed = false
    }
    
    private func buttonTapped(number: Int) {
        if isFirstFieldFilled {
            fillSecondField(number: number)
        } else {
            fillFirstField(number: number)
        }
    }
    
    private func fillFirstField(number: Int) {
        if counter < 4 {
            isFirstFieldDotFilled[counter].toggle()
            counter += 1
            firstEnteredPasscode += String(number)
            
            if counter == 4 {
                isFirstFieldFilled = true
                counter = 0
            }
        }
    }
    
    private func fillSecondField(number: Int) {
        if counter < 4 {
            isSecondFieldDotFilled[counter].toggle()
            counter += 1
            secondEnteredPasscode += String(number)
            
            if counter == 4 {
                checkPasscodes()
            }
        }
    }
    
    private func deleteButton() {
        if isFirstFieldFilled {
            if counter > 0 {
                counter -= 1
                isSecondFieldDotFilled[counter].toggle()
                secondEnteredPasscode = String(secondEnteredPasscode.dropLast())
                
                if counter == 0 {
                    counter = 4
                    isFirstFieldFilled = false
                }
            } else {
                counter = 3
                isFirstFieldFilled = false
                isFirstFieldDotFilled[counter].toggle()
                firstEnteredPasscode = String(firstEnteredPasscode.dropLast())
            }
        } else {
            if counter > 0 {
                counter -= 1
                isFirstFieldDotFilled[counter].toggle()
                firstEnteredPasscode = String(firstEnteredPasscode.dropLast())
            }
        }
    }
    
    private func checkPasscodes() {
        if firstEnteredPasscode == secondEnteredPasscode {
            passcode = secondEnteredPasscode
            isPasscodeUsed = true
            presentation.wrappedValue.dismiss()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                
                withAnimation(.easeIn) {
                    isErrorTextShown = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeOut) {
                        isErrorTextShown = false
                    }
                }
                
                counter = 0
                isFirstFieldFilled = false
                firstEnteredPasscode = ""
                secondEnteredPasscode = ""
                isFirstFieldDotFilled = [Bool](repeating: false, count: 4)
                isSecondFieldDotFilled = [Bool](repeating: false, count: 4)
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
