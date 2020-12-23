//
//  SelectedEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct SelectedEntryView: View {
    @Binding var entry: Entry
    @State var onEdit = false
    @State private var entryText: String = ""
    @State private var showAlert = false
    
    var body: some View {
        VStack {
                if onEdit {
                    if #available(iOS 14.0, *) {
                        TextEditor(text: $entryText)
                            .autocapitalization(.sentences)
                            .onChange(of: entryText, perform: { value in
                                self.entryText = entryText
                            })
                    } else {
                        // Fallback on earlier versions
                    }
                } else {
                    ScrollView {
                        Text(entry.text)
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
            Alert(title: Text("Do you want to delete this etry?"), primaryButton: .destructive(Text("Delete"), action: {
                deleteEntry()
            }), secondaryButton: .cancel())
        }
        .padding()
    }
    
    private func editEntry() {
        entryText = entry.text
    }
    
    private func saveEntry() {
        if !entryText.isEmpty {
            entry.text = entryText
        } else {
            self.showAlert = true
        }
    }
    
    private func deleteEntry() {
        
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        SelectedEntryView(entry: .constant(Entry(text: "hhh", date: 999, dateString: "")))
        //        .environment(\.colorScheme, .dark)
    }
}
