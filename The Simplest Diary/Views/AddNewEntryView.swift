//
//  AddNewEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct AddNewEntryView: View {
    @Binding var entries: [Entry]
    @State private var entryText: String = "Write something..."
    @Environment(\.presentationMode) var presentation
    private let placeholder = "Write something..."

    var body: some View {
        VStack {
            if #available(iOS 14.0, *) {
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
            } else {}
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
            let entry: Entry = Entry(text: entryText, date: NSTimeIntervalSince1970, dateString: makeDate())
            entries.append(entry)
//            let AAAAAAAA = Entries()
//            AAAAAAAA.addNewEntry(entry: entry)
            self.presentation.wrappedValue.dismiss()
        }
    }
    
    private func makeDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy 'at' h:mm a"
        return dateFormatter.string(from: Date())
    }
}

struct AddNewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEntryView(entries: .constant([Entry(text: "", date: 999, dateString: "")]))
    }
}
