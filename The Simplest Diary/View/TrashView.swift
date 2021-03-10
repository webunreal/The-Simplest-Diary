//
//  TrashView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 26.12.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
struct TrashView: View {
    
    var body: some View {
        PageView(page: .trash)
    }
}

@available(iOS 14.0, *)
struct TrashView_Previews: PreviewProvider {
    static var previews: some View {
        TrashView()
    }
}
