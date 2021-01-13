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
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var entry: Entry
    
    var body: some View {
        ScrollView(.vertical) {
            Text(entry.text ?? "")
        }
        .padding()
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack(spacing: 40) {
                    Button(action: {
                        deleteEntry()
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    Button(action: {
                        recoverEntry()
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("Recover")
                    }
                })
    }
    
    private func deleteEntry() {
        self.managedObjectContext.delete(entry)
        
        saveContext()
    }
    
    private func recoverEntry() {
        entry.isTrashed = false
        entry.offset = 0
        entry.isSwiped = false
        
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

//@available(iOS 14.0, *)
//struct TrashedEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrashedEntryView()
//    }
//}
