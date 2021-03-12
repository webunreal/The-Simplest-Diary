//
//  TrashedEntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 26.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import CoreHaptics

@available(iOS 14.0, *)
struct TrashedEntryView: View {
    @Environment(\.presentationMode) var presentation
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var entry: Entry
    @State private var showAlertDeleteOneEntry: Bool = false
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        ScrollView(.vertical) {
            Text(entry.text ?? "")
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 40) {
                    Button {
                        showAlertDeleteOneEntry = true
                    } label: {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    Button {
                        recoverEntry()
                        presentation.wrappedValue.dismiss()
                    } label: {
                        Text("Recover")
                    }
                }
            }
        }
        .alert(isPresented: $showAlertDeleteOneEntry) {
            Alert(title: Text("Delete this entry?"), primaryButton: .destructive(Text("Delete"), action: {
                deleteEntry()
                presentation.wrappedValue.dismiss()
            }), secondaryButton: .cancel())
        }
    }
    
    private func deleteEntry() {
        self.managedObjectContext.delete(entry)
        saveContext()
    }
    
    private func recoverEntry() {
        entry.isTrashed = false
        saveContext()
    }
    
    private func saveContext() {
        haptic.impactOccurred()
        
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
