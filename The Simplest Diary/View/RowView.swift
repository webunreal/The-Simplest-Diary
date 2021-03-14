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
    @State private var currentEntryOffset: CGFloat = 0
    
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
            
            // MARK: - Selection
            Button {
                entry.isSelected.toggle()
            } label: {
                SelectionView(isFilled: entry.isSelected)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showingSelection ? 1 : 0)
            }
            .frame(width: showingSelection ? selectionWidth : 0)
            
            ZStack {
                HStack(spacing: 0) {
                    
                    // MARK: - Pin
                    if page != .trash {
                        Button {
                            pinEntry()
                        } label: {
                            Image(systemName: entry.isPinned ? "pin.slash.fill" : "pin.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .opacity(currentLeftSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
                        }
                        .frame(maxWidth: currentLeftSwipeFrameWidth)
                        .background(Color.orange)
                    }
                    
                    Spacer()
                    
                    // MARK: - Recover
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
                    
                    // MARK: - Delete
                    Button {
                        switch page {
                        case .home:
                            moveToTrash()
                        case .pinned:
                            moveToTrash()
                        case.trash:
                            deleteOneEntryAlert = Alert(
                                title: Text("Delete this entry?"),
                                primaryButton: .destructive(Text("Delete"), action: {
                                    deleteEntryFromTrash()
                                }), secondaryButton: .cancel() {
                                    removeSwipes()
                                    
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
                    .frame(maxWidth: currentRightSwipeFrameWidth)
                    .background(Color.red)
                }
                
                // MARK: - Body
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
                            .rotationEffect(.degrees(45))
                            .opacity(entry.isPinned ? 1: 0)
                            .padding(.trailing, 15)
                    }
                    .background(
                        Color(colorScheme == .dark ?
                                .secondarySystemBackground :
                                .systemFill)
                    )
                    
                    Text(entry.text ?? "Error")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                        .frame(maxWidth: .infinity, minHeight: entryHeight, alignment: .topLeading)
                        .padding(EdgeInsets(top: 1, leading: 15, bottom: 10, trailing: 15))
                }
                .background(Color("cardBackgroud"))
                .offset(x: currentEntryOffset)
            }
            .cornerRadius(15)
        }
        .onAppear(perform: removeSwipes)
        .animation(.easeIn(duration: 0.1))
        .onChange(of: showingSelection) { _ in
            removeSwipes()
        }
        .gesture(DragGesture(minimumDistance: 20)
                    .onChanged { value in
                        if abs(value.location.y - value.startLocation.y) < 10 {
                            swipeOnChanged(swipe: value.location.x - value.startLocation.x)
                        }
                    }
                    .onEnded {value in
                        swipeOnEnded(swipe: value.location.x - value.startLocation.x)
                    }
        )
    }
    
    private func pinEntry() {
        haptic.impactOccurred()
        entry.isPinned.toggle()
        saveContext()
        removeSwipes()
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
    
    private func swipeOnChanged(swipe: CGFloat) {
        if !showingSelection {
            if swipe > 0 {
                if currentRightSwipeFrameWidth == 0 && page != .trash {
                    currentEntryOffset = swipe
                    currentLeftSwipeFrameWidth = swipe
                } 
            } else if swipe < 0 {
                if currentLeftSwipeFrameWidth == 0 {
                    if page == .trash {
                        if -swipe > swipeOptionsWidth {
                            currentEntryOffset = 2 * -swipeOptionsWidth
                            currentRightSwipeFrameWidth = swipeOptionsWidth
                        } else {
                            currentEntryOffset = 2 * swipe
                            currentRightSwipeFrameWidth = -swipe
                        }
                    } else {
                        currentEntryOffset = swipe
                        currentRightSwipeFrameWidth = -swipe
                    }
                }
            }
        }
    }
    
    private func swipeOnEnded(swipe: CGFloat) {
        if !showingSelection {
            if swipe > 0 {
                if currentRightSwipeFrameWidth == 0 && page != .trash {
                    if swipe > 3 * swipeOptionsWidth {
                        pinEntry()
                    } else if swipe > swipeOptionsWidth {
                        currentEntryOffset = swipeOptionsWidth
                        currentLeftSwipeFrameWidth = swipeOptionsWidth
                    } else {
                        removeSwipes()
                    }
                } else {
                    removeSwipes()
                }
            } else if swipe < 0 {
                if currentLeftSwipeFrameWidth == 0 {
                    if -swipe > 3 * swipeOptionsWidth && page != .trash {
                        moveToTrash()
                        removeSwipes()
                    } else if -swipe > swipeOptionsWidth {
                        if page == .trash {
                            currentEntryOffset = 2 * -swipeOptionsWidth
                            currentRightSwipeFrameWidth = swipeOptionsWidth
                        } else {
                            currentEntryOffset = -swipeOptionsWidth
                            currentRightSwipeFrameWidth = swipeOptionsWidth
                        }
                    } else {
                        removeSwipes()
                    }
                } else {
                    removeSwipes()
                }
            }
        }
    }
    
    private func removeSwipes() {
        currentRightSwipeFrameWidth = 0
        currentLeftSwipeFrameWidth = 0
        currentEntryOffset = 0
    }
}

// @available(iOS 14.0, *)
// struct RowView_Previews: PreviewProvider {
//    static var previews: some View {
//        RowView(entry: Entry(), page: .home)
//           .environment(\.colorScheme, .dark)
//    }
// }
