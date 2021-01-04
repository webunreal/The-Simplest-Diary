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
//    @EnvironmentObject var entries1: Entries
    var entry: Entry
//    @Binding var entries: [Entry]
//    var index: Int
    private static let dateFormat: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .current
        return dateFormatter
    }()
    
    var body: some View {
//        ZStack {
//            LinearGradient(gradient: .init(colors: [Color("cardBackgroud"), Color(.red)]), startPoint: .leading, endPoint: .trailing)
//                .cornerRadius(15)
//            HStack {
//                Spacer()
//                Button(action: {
//                    withAnimation(.easeIn){deleteItem()}
//
//                }) {
//                    Image(systemName: "trash")
//                        .font(.title)
//                        .foregroundColor(.white)
//                        .frame(width: 90, height: 50)
//                }
//            }
            VStack(alignment: .leading) {
                Text(entry.date, formatter: RowView.dateFormat)
                    .font(.system(size: 15))
                    .padding(.bottom, 5)
                Text(entry.text)
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 20))
                    .lineLimit(5)
            }
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)
            .padding()
            .background(Color("cardBackgroud"))
            .cornerRadius(15)
//            .contentShape(Rectangle())
//            .offset(x: entry.offset)
//            .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnded(value:)))
//        }
    }
    
//    private func onChanged(value: DragGesture.Value) {
//        if value.translation.width < 0 {
//            if entry.isSwiped {
//                entry.offset = value.translation.width - 90
//            } else {
//                entry.offset = value.translation.width
//            }
//        }
//    }
    
//    private func onEnded(value: DragGesture.Value) {
//        withAnimation(.easeOut) {
//            if value.translation.width < 0 {
//                if -value.translation.width > UIScreen.main.bounds.width / 2 {
//                    entry.offset = -1000
//                    deleteItem()
//                } else if -entry.offset > 50 {
//                    entry.isSwiped = true
//                    entry.offset = -90
//                } else {
//                    entry.isSwiped = false
//                    entry.offset = 0
//                }
//            } else {
//                entry.isSwiped = false
//                entry.offset = 0
//            }
//        }
//    }
    
//    private func deleteItem() {
//        entries1.moveTotrash(index: index)
//        entries.removeAll()
//        { (entry) -> Bool in
//            print(entry)
//            print("_______")
//            return self.entry.id == entry.id
//        }
//    }
}

//@available(iOS 14.0, *)
//struct RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowView(entry: .constant(Entry(id: "1", text: "22", date: Date(), offset: 0, isSwiped: false)), entries: .constant([Entry(id: "", text: "", date: Date(), offset: 0, isSwiped: true)]))
//        .environment(\.colorScheme, .dark)
//    }
//}

