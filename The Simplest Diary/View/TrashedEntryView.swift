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
    @EnvironmentObject var entries: Entries
    @Environment(\.presentationMode) var presentation
    var index: Int
    
    var body: some View {
        if entries.trashedEntriesList.isEmpty {
            EmptyView()
        } else {
                ScrollView(.vertical) {
                    Text(entries.trashedEntriesList[index].text)
                }
                .padding()
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(
                    trailing:
                        HStack(spacing: 40) {
                            Button(action: {
                                entries.deleteOneEntryFromTrash(index: index)
                                self.presentation.wrappedValue.dismiss()
                            }) {
                                Text("Delete")
                                    .foregroundColor(.red)
                            }
                            Button(action: {
                                entries.recoverOneEntryFromTrash(index: index)
                                self.presentation.wrappedValue.dismiss()
                            }) {
                                Text("Recover")
                            }
                    })
        }
    }
}

@available(iOS 14.0, *)
struct TrashedEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TrashedEntryView(index: 0)
    }
}
