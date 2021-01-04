//
//  NoEntriesView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 28.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct NoEntriesView: View {
    var body: some View {
        Text("No Entries")
            .font(.system(size: 30))
            .fontWeight(.bold)
            .foregroundColor(Color("cardBackgroud"))
    }
}

struct NoEntriesView_Previews: PreviewProvider {
    static var previews: some View {
        NoEntriesView()
    }
}
