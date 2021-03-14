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
    @State private var showSavingEmptyEntryAlert = false
    
    var body: some View {
        VStack {
            if onEdit {
                TextEditor(text: $entryText)
                    .autocapitalization(.sentences)
                    .onChange(of: entryText) { _ in
                        entryText = entryText
                    }
            } else {
                ScrollView(.vertical) {
                    Text(entry.text ?? "Error")
                }
            }
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    onEdit.toggle()
                    onEdit ? editEntry() : saveEntry()
                } label: {
                    Text(onEdit ? "Save" : "Edit")
                }
            }
        }
        .alert(isPresented: $showSavingEmptyEntryAlert) {
            Alert(
                title: Text("Do you want to save empty entry?"),
                primaryButton: .default(Text("Save"), action: {
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
            showSavingEmptyEntryAlert = true
        }
    }
    
    private func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
        
        presentation.wrappedValue.dismiss()
    }
}

// @available(iOS 14.0, *)
// struct EntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailedEntryView()
//    }
// }
