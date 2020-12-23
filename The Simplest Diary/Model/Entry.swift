//
//  Model.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import Foundation

struct Entry: Hashable {
    var text: String
    var date: Double
    var dateString: String
}

class Entries: ObservableObject {
    @Published var entriesList: [Entry] = [
        Entry(text: "Example", date: 5776565678, dateString: "2020-12-23 19:22:06"),
        Entry(text: "Example 2", date: 4545624256, dateString: "2020-12-25 19:22:06")
    ]
    
    func addNewEntry(entry: Entry) {
        entriesList.append(entry)
    }
}


