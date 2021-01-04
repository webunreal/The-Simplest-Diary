//
//  MenuButtonView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 30.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct MenuButtonView: View {
    var body: some View {
        Image(systemName: "ellipsis.circle")
            .foregroundColor(Color("menuColor"))
            .frame(width: 30, height: 80)
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView()
    }
}
