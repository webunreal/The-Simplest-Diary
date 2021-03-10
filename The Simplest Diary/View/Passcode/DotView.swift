//
//  DotView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 13.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct DotView: View {
    var isFilled: Bool
    
    var body: some View {
        Circle()
            .foregroundColor(isFilled ? Color("cardBackgroud") : Color(.clear))
            .frame(width: 30, height: 30)
            .overlay(
                Circle()
                    .stroke(Color("cardBackgroud"), lineWidth: 1)
            )
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        DotView(isFilled: true)
    }
}
