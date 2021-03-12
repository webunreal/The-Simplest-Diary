//
//  PinnedView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 13.03.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
@available(iOS 14.0, *)

struct PinnedView: View {
    var body: some View {
        PageView(page: .pinned)
    }
}

@available(iOS 14.0, *)
struct PinnedView_Previews: PreviewProvider {
    static var previews: some View {
        PinnedView()
    }
}
