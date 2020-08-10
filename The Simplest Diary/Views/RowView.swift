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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.date)
                .padding(.bottom, 5)
            Text(entry.text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20))
                .lineLimit(5)

        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading) //minHeight: 145
        .padding()
        .background(self.colorScheme == .dark ? Color.darkCardBackground : Color.lightCardBackground)
        .cornerRadius(15)
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(entry: entriesList[0])
//        .environment(\.colorScheme, .dark)
    }
}

