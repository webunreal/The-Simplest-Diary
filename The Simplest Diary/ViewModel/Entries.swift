//
//  Entries.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import Foundation

class Entries: ObservableObject {
    @Published var entriesList: [Entry] = [
        Entry(text: "Example", date: Date(timeIntervalSince1970: 122256789.0), offset: 0, isSwiped: false)
    ]
    
    @Published var trashedEntriesList: [Entry] = []
    
    func addNewEntry(entry: Entry) {
        entriesList.append(entry)
    }
    
    func moveTotrash(index: Int) {
        entriesList[index].offset = 0
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
