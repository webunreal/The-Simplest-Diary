//
//  Model.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

struct Entry: Hashable {
//    var id = UUID().uuidString
    var text: String
    var date: Date
    var offset: CGFloat
    var isSwiped: Bool
}

class Entries: ObservableObject {
    @Published var entriesList: [Entry] = [
        Entry(text: "Example", date: Date(timeIntervalSince1970: 122256789.0), offset: 0, isSwiped: false),
        Entry(text: "Example2", date: Date(timeIntervalSince1970: 1234567899.0), offset: 0, isSwiped: false)
    ]
    
    @Published var trashedEntriesList: [Entry] = [
        Entry(text: "ExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExampleExample", date: Date(timeIntervalSince1970: 12345699979.0), offset: 0, isSwiped: false),
        ]
    
    func addNewEntry(entry: Entry) {
        entriesList.append(entry)
    }
    
    func moveTotrash(index: Int) {
        trashedEntriesList.append(entriesList[index])
        entriesList.remove(at: index)
    }
    
    func deleteOneEntryFromTrash(index: Int){
        trashedEntriesList.remove(at: index)
    }
    
    func recoverOneEntryFromTrash(index: Int) {
        entriesList.append(trashedEntriesList[index])
        sortEntriesList()
        trashedEntriesList.remove(at: index)
    }
    
    func deleteAllEntriesFromTrash() {
        trashedEntriesList.removeAll()
    }
    
    func recoverAllEntriesFromTrash() {
        entriesList += trashedEntriesList
        trashedEntriesList.removeAll()
        sortEntriesList()
    }
    
    private func sortEntriesList() {
        entriesList = entriesList.sorted(by: { $0.date < $1.date })
    }
    
    
}


