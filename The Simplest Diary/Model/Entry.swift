//
//  Entry.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct Entry: Hashable, Identifiable {
    var id = UUID().uuidString
    var text: String
    var date: Date
    var offset: CGFloat
    var isSwiped: Bool
}
