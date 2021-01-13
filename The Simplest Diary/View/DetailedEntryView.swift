//
//  DetailedEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
@available(iOS 14.0, *)

struct DetailedEntryView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var entry: Entry
    @State private var onEdit = false
    @State var entryText: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            if onEdit {
                TextEditor(text: $entryText)
                    .autocapitalization(.sentences)
                    .onChange(of: entryText, perform: { value in
                        self.entryText = entryText
                    })
            } else {
                ScrollView(.vertical) {
                    Text(entry.text ?? "Error")
                }
            }
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.onEdit.toggle()
            self.onEdit ? editEntry() : saveEntry()
        }) {
            Text(onEdit ? "Save" : "Edit")
        })
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Do you want to save empty entry?"), primaryButton: .destructive(Text("Yes"), action: {
                        entry.text = ""
                        saveContext()
                    }), secondaryButton: .cancel())
                }
        .padding()
    }
    
    private func editEntry() {
        entryText = entry.text ?? "Error"
    }
    
    private func saveEntry() {
        if !entryText.isEmpty {
            entry.text = entryText
            saveContext()
        } else {
            self.showAlert = true
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        self.presentation.wrappedValue.dismiss()
    }
}

//@available(iOS 14.0, *)
//struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedEntryView()
//    }
//}
