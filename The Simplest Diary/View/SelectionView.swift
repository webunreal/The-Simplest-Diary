//
//  SelectionView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 24.01.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct SelectionView: View {
    var isFilled: Bool
    private let dotFrame: CGFloat = 20
    
    var body: some View {
        if self.isFilled {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: dotFrame, height: dotFrame)
                .foregroundColor(Color("cardBackgroud"))
        } else {
            Circle()
                .stroke(Color("cardBackgroud"), lineWidth: 1)
                .frame(width: dotFrame, height: dotFrame)
        }
    }
}

struct SelectDotView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView(isFilled: true)
    }
}
