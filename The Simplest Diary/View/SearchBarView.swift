//
//  SearchBarView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 21.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                TextField("Search", text: $searchText) { _ in
                    showCancelButton = true
                }
                .foregroundColor(.primary)
                
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .padding(.trailing, 10)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            
            if showCancelButton {
                Button("Cancel") {
                    endEditing()
                    searchText = ""
                    showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
