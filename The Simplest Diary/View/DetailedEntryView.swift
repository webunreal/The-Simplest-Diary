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
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    @Environment(\.presentationMode) var presentation
    var index: Int
    @State var onEdit = false
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
                    Text(entries[index].text ?? "Error")
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
        .padding()
    }
    
    private func editEntry() {
        entryText = entries[index].text ?? "Error"
    }
    
    private func saveEntry() {
        entries[index].text = entryText
        saveContext()
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

@available(iOS 14.0, *)
struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedEntryView(index: 0)
        //        .environment(\.colorScheme, .dark)
    }
}
