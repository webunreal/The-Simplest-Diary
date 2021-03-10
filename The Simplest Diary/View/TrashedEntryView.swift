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
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack(spacing: 40) {
                    Button(action: {
                        self.showAlertDeleteOneEntry = true
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showAlertDeleteOneEntry) {
                        Alert(title: Text("Delete this entry?"), primaryButton: .destructive(Text("Yes"), action: {
                            deleteEntry()
                            self.presentation.wrappedValue.dismiss()
                        }), secondaryButton: .cancel())
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
