//
//  PasscodeButtonView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 13.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct PasscodeButtonView: View {
    var number: Int
    
    var body: some View {
        Text("\(number)")
            .font(.system(size: 40))
            .frame(width: 80, height: 80)
            .foregroundColor(.primary)
            .background(Color.clear)
            .clipShape(Circle())
    }
}

struct PassCodeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PasscodeButtonView(number: 1)
    }
}
