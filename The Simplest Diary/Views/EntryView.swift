//
//  EntryView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct EntryView: View {
    let entry: String
    var body: some View {
        VStack {
            Text(entry)
            .padding()
            Text("Date")
                .frame(maxWidth: .infinity, alignment: .trailing)
            Spacer()
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView(entry: entriesList[0].text)
//        .environment(\.colorScheme, .dark)
    }
}
