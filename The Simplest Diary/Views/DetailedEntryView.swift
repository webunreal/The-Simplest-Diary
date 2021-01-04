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
    @EnvironmentObject var entries: Entries
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
                    Text(entries.entriesList[index].text)
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
            Alert(title: Text("Do you want to save empty etry?"), primaryButton: .destructive(Text("Yes"), action: {
                saveEmptyEntry()
            }), secondaryButton: .cancel())
        }
        .padding()
    }
    
    private func editEntry() {
        entryText = entries.entriesList[index].text
    }
    
    private func saveEntry() {
        if !entryText.isEmpty {
            entries.entriesList[index].text = entryText
        } else {
            self.showAlert = true
        }
    }
    
    private func saveEmptyEntry() {
        entries.entriesList[index].text = entryText
    }
}

@available(iOS 14.0, *)
struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedEntryView(index: 0)
        //        .environment(\.colorScheme, .dark)
    }
}
