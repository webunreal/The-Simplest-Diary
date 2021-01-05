//
//  TrashedEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 26.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrashedEntryView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Entry.entity(), sortDescriptors: []) var entries: FetchedResults<Entry>
    @Environment(\.presentationMode) var presentation
    var index: Int
    
    var body: some View {
        if entries.filter({$0.isTrashed}).isEmpty {
            EmptyView()
        } else {
            ScrollView(.vertical) {
                Text(entries[index].text ?? "Error")
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(
                trailing:
                    HStack(spacing: 40) {
                        Button(action: {
                            deleteOneEntryFromTrash(index: index)
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text("Delete")
                                .foregroundColor(.red)
                        }
                        Button(action: {
                            recoverOneEntryFromTrash(index: index)
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text("Recover")
                        }
                    })
        }
    }
    
    private func recoverOneEntryFromTrash(index: Int) {
        entries[index].isTrashed = false
        saveContext()
    }
    
    private func deleteOneEntryFromTrash(index: Int) {
        self.managedObjectContext.delete(entries[index])
        saveContext()
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
struct TrashedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TrashedEntryView(index: 0)
    }
}
