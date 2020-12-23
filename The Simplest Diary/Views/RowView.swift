//
//  RowView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 10.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct RowView: View {
    var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.dateString)
                .padding(.bottom, 5)
            Text(entry.text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20))
                .lineLimit(5)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        .padding()
        .background(Color("cardBackgroud"))
        .cornerRadius(15)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        let entries = Entries()
        RowView(entry: entries.entriesList[0])
        .environment(\.colorScheme, .dark)
    }
}

