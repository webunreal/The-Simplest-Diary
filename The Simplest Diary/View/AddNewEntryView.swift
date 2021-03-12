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
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var entryText: String = "Write something..."
    private let placeholder = "Write something..."
    
    var body: some View {
        VStack {
            TextEditor(text: $entryText)
                .autocapitalization(.sentences)
                .foregroundColor(entryText == placeholder ? .gray : .primary)
                .onTapGesture {
                    if entryText == placeholder {
                        entryText = ""
                    }
                }
                .onChange(of: entryText, perform: { value in
                    entryText = entryText
                })
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveEntry()
                } label: {
                    Text("Save")
                }
            }
        }
        .padding()
    }
    
    private func saveEntry() {
        if entryText == placeholder {
            presentation.wrappedValue.dismiss()
        } else {
            saveContext()
            presentation.wrappedValue.dismiss()
        }
    }
    
    private func saveContext() {
        let newEntry = Entry(context: self.managedObjectContext)
        newEntry.id = UUID()
        newEntry.text = entryText
        newEntry.date = Date()
        newEntry.isTrashed = false
        newEntry.isSelected = false
        
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
