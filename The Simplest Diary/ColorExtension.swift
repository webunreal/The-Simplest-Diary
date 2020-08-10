//
//  ColorExtension.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 10.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }

    public static var lightCardBackground: Color {
        return Color(decimalRed: 230, green: 230, blue: 230)
    }

    public static var darkCardBackground: Color {
        return Color(decimalRed: 46, green: 46, blue: 46)
    }
}

//extension UIColor {
//
//    static let flatDarkBackground = UIColor(red: 36, green: 36, blue: 36)
//    static let flatDarkCardBackground = UIColor(red: 46, green: 46, blue: 46)
//
//    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
//        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
//    }
//}
