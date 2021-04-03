//
//  Entry.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 03.04.2021.
//  Copyright © 2021 Nikolai Ivanov. All rights reserved.
//

import CoreData

final class Entry: NSManagedObject {
    @NSManaged var date: Date?
    @NSManaged var id: UUID?
    @NSManaged var isPinned: Bool
    @NSManaged var isSelected: Bool
    @NSManaged var isTrashed: Bool
    @NSManaged var text: String?
    
    static func getEntryFetchRequest() -> NSFetchRequest<Entry> {
        let request = NSFetchRequest<Entry>(entityName: "Entry")
        request.sortDescriptors = []
        return request
    }
}
