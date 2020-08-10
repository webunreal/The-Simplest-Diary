//
//  Model.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 06.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import Foundation

struct Entry {
    var text: String
    var date: String
}

var entriesList: [Entry] = [
    Entry(text: "In Swift, dates and times are stored in a 64-bit floating point number measuring the number of seconds since the reference date of January 1, 2001 at 00:00:00 UTC. This is expressed in the Date structure. The following would give you the current date and time:", date: "13.02.2018"),
    Entry(text: "Please note that this implementation does not cache the NSDateFormatter, which you might want to do for performance reasons if you expect to be creating many NSDates in this way. Please also note that this implementation will simply crash if you try to initialize an NSDate by passing in a string that cannot be parsed correctly. This is because of the forced unwrap of the optional value returned by dateFromString. If you wanted to return a nil on bad parses, you would ideally use a failible initializer; but you cannot do that now (June 2015), because of a limitation in Swift 1.2, so then you're next best choice is to use a class factory method.", date: "12.05.2019"),
    Entry(text: "ololo", date: "06.07.2020")
]
