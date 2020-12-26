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
        Entry(text: "Example", date: 978307200.0, dateString: "Thursday, December 24, 2020 at 8:56 PM"),
        Entry(text: "Example2", date: 978307200.0, dateString: "Thursday, December 24, 2020 at 8:56 PM")
    ]
    
    @Published var deletedEntriesList: [Entry] = []
    
    func moveTotrash(entry: Entry, index: Int) {
        deletedEntriesList.append(entry)
        entriesList.remove(at: index)
    }
    
    func addNewEntry(entry: Entry) {
        entriesList.append(entry)
    }
}


