//
//  AddNewEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
@available(iOS 14.0, *)

struct AddNewEntryView: View {
    @EnvironmentObject var entries: Entries
    @State private var entryText: String = "Write something..."
    @Environment(\.presentationMode) var presentation
    private let placeholder = "Write something..."
    
    var body: some View {
        VStack {
            TextEditor(text: $entryText)
                .autocapitalization(.sentences)
                .foregroundColor(self.entryText == placeholder ? .gray : .primary)
                .onTapGesture {
                    if self.entryText == placeholder {
                        self.entryText = ""
                    }
                }
                .onChange(of: entryText, perform: { value in
                    self.entryText = entryText
                })
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            saveButtonActions()
        }) {
            Text("Save")
        })
        .padding()
    }
    
    private func saveButtonActions() {
        if entryText.isEmpty {
            self.presentation.wrappedValue.dismiss()
        } else {
            let entry: Entry = Entry(text: entryText, date: Date(), offset: 0, isSwiped: false)
            entries.addNewEntry(entry: entry)
            self.presentation.wrappedValue.dismiss()
        }
    }
}

@available(iOS 14.0, *)
struct AddNewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEntryView()
    }
}