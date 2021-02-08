//
//  RowView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 10.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)

struct RowView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var date: Date
    var text: String
    
    private static let dateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    private var entryHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 120
        } else {
            return 80
        }
    }
    
    var body: some View {
        VStack {
            Text(date, formatter: RowView.dateFormat)
                .font(.footnote)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, minHeight: 15, alignment: .leading)
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                .background(Color(colorScheme == .dark ?
                                    .secondarySystemBackground :
                                    .systemFill
                ))
                .cornerRadius(15, corners: [.topLeft, .topRight])
            
            Text(text)
                .font(.system(size: 20))
                .multilineTextAlignment(.leading)
                .lineLimit(5)
                .frame(maxWidth: .infinity, minHeight: entryHeight, alignment: .topLeading)
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
        }
        .background(Color("cardBackgroud"))
        .cornerRadius(15)
    }
}

@available(iOS 14.0, *)
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(date: Date(), text: "text")
//            .environment(\.colorScheme, .dark)
    }
}

