//
//  RowView.swift
//  The Simplest Diary
//
//  Created by Nikolai Ivanov on 10.08.2020.
//  Copyright © 2020 Nikolai Ivanov. All rights reserved.
//

import SwiftUI
import CoreHaptics

@available(iOS 14.0, *)

struct RowView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var entry: Entry
    
    @Binding var showingSelection: Bool
    @Binding var showAlertDeleteOneEntry: Bool
    @Binding var deleteOneEntryAlert: Alert?
    @State private var currentRightSwipeFrameWidth: CGFloat = 0
    @State private var currentLeftSwipeFrameWidth: CGFloat = 0
    
    public let page: Page
    
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
    
    private var selectionWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.width / 16
        } else {
            return UIScreen.main.bounds.width / 8
        }
    }
    
    private var swipeOptionsWidth: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.width / 12
        } else {
            return UIScreen.main.bounds.width / 6
        }
    }
    
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                entry.isSelected.toggle()
            } label: {
                SelectionView(isFilled: entry.isSelected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showingSelection ? 1 : 0)
            }
            .frame(width: showingSelection ? selectionWidth : 0)
            
            Button {
                entry.isPinned.toggle()
                currentLeftSwipeFrameWidth = 0
            } label: {
                Image(systemName: entry.isPinned ? "pin.slash.fill" : "pin.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(currentLeftSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
            }
            .frame(width: currentLeftSwipeFrameWidth)
            .background(Color.orange)
            
            VStack {
                HStack(spacing: 0) {
                    Text(entry.date ?? Date(), formatter: RowView.dateFormat)
                        .font(.footnote)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 15, alignment: .leading)
                        .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    
                        Image(systemName: "pin.fill")
                            .foregroundColor(.orange)
                            .opacity(entry.isPinned ? 1: 0)
                            .padding(.trailing, 15)
                }
                .background(
                    Color(colorScheme == .dark ?
                            .secondarySystemBackground :
                            .systemFill)
                )
                .cornerRadius(showingSelection ? 15 : 0, corners: [.topLeft])
                
                Text(entry.text ?? "Error")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .frame(maxWidth: .infinity, minHeight: entryHeight, alignment: .topLeading)
                    .padding(EdgeInsets(top: 1, leading: 15, bottom: 10, trailing: 15))
            }
            .background(Color("cardBackgroud"))
            .cornerRadius(showingSelection ? 15 : 0, corners: [.topLeft, .bottomLeft])
            
            if page == .trash {
                Button {
                    recoverEntryFromTrash()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(currentRightSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
                }
                .frame(width: currentRightSwipeFrameWidth)
                .background(Color.blue)
            }
            
            Button {
                switch page {
                case .home:
                    moveToTrash()
                case .pinned:
                    moveToTrash()
                case.trash:
                    deleteOneEntryAlert =  Alert(title: Text("Delete this entry?"), primaryButton: .destructive(Text("Delete"), action: {
                        deleteEntryFromTrash()
                    }), secondaryButton: .cancel() {
                        currentRightSwipeFrameWidth = 0
                        
                    })
                    showAlertDeleteOneEntry = true
                }
            } label: {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(currentRightSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
            }
            .frame(width: currentRightSwipeFrameWidth)
            .background(Color.red)
        }
        .cornerRadius(15)
        .animation(.spring())
        .onChange(of: showingSelection) { _ in
            currentRightSwipeFrameWidth = 0
        }
        .gesture(DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        swipeOnChanged(value: value)
                    }
                    .onEnded {value in
                        swipeOnEnded(value: value)
                    }
        )
    }
    
    private func moveToTrash() {
        entry.isTrashed = true
        entry.isPinned = false
        saveContext()
    }
    
    private func deleteEntryFromTrash() {
        self.managedObjectContext.delete(entry)
        saveContext()
    }
    
    private func recoverEntryFromTrash() {
        entry.isTrashed = false
        saveContext()
    }
    
    private func saveContext() {
        haptic.impactOccurred()
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error)")
        }
    }
    
    private func swipeOnChanged(value: DragGesture.Value) {
        if !showingSelection {
            if value.translation.width < 0 && currentLeftSwipeFrameWidth == 0 {
                if value.translation.width < -swipeOptionsWidth {
                    currentRightSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentRightSwipeFrameWidth = -value.translation.width
                }
            } else if value.translation.width > 0 && currentRightSwipeFrameWidth == 0 {
                if value.translation.width > swipeOptionsWidth {
                    currentLeftSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentLeftSwipeFrameWidth = value.translation.width
                }
            }
        }
    }
    
    private func swipeOnEnded(value: DragGesture.Value) {
        if !showingSelection {
            if value.translation.width < 0 {
                if currentLeftSwipeFrameWidth == 0 {
                    currentRightSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentLeftSwipeFrameWidth = 0
                }
            } else if value.translation.width > 0 {
                if currentRightSwipeFrameWidth == 0 {
                    currentLeftSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentRightSwipeFrameWidth = 0
                }
            }
        }
    }
}

//@available(iOS 14.0, *)
//struct RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowView(entry: Entry(), page: .home)
//           .environment(\.colorScheme, .dark)
//    }
//}
