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
    @Environment(\.managedObjectContext) var managedObjectContext
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
            saveEntry()
        }) {
            Text("Save")
        })
        .padding()
    }
    
    private func saveEntry() {
        if entryText.isEmpty {
            self.presentation.wrappedValue.dismiss()
        } else {
            let newEntry = Entry(context: self.managedObjectContext)
            newEntry.id = UUID()
            newEntry.text = entryText
            newEntry.date = Date()
            newEntry.offset = 0
            newEntry.isSwiped = false
            newEntry.isTrashed = false
            
            saveContext()
            
            self.presentation.wrappedValue.dismiss()
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
}

@available(iOS 14.0, *)
struct AddNewEntryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewEntryView()
    }
}
