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
    var date: Date
    var text: String    
    private static let dateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date, formatter: RowView.dateFormat)
                .font(.system(size: 15))
                .padding(.bottom, 5)
            Text(text)
                .multilineTextAlignment(.leading)
                .font(.system(size: 20))
                .lineLimit(5)
        }
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
        .padding()
        .background(Color("cardBackgroud"))
        .cornerRadius(15)
    }
}

@available(iOS 14.0, *)
struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(date: Date(), text: "text")
            .environment(\.colorScheme, .dark)
    }
}

