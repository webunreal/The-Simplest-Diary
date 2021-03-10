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
    
    @Binding public var showingSelection: Bool
    @State private var showDeletingAlert: Bool = false
    @State private var showAlertDeleteOneEntry: Bool = false
    @State private var currentSwipeFrameWidth: CGFloat = 0
    
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
            
            VStack {
                Text(entry.date ?? Date(), formatter: RowView.dateFormat)
                    .font(.footnote)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 15, alignment: .leading)
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    .background(
                        Color(colorScheme == .dark ?
                                .secondarySystemBackground :
                                .systemFill)
                    )
                    .cornerRadius(15, corners: [.topLeft])
                
                Text(entry.text ?? "Error")
                    .font(.system(size: 20))
                    .multilineTextAlignment(.leading)
                    .lineLimit(5)
                    .frame(maxWidth: .infinity, minHeight: entryHeight, alignment: .topLeading)
                    .padding(EdgeInsets(top: 0, leading: 15, bottom: 10, trailing: 15))
            }
            .background(Color("cardBackgroud"))
            .cornerRadius(15, corners: [.topLeft, .bottomLeft])
            
            if page == .trash {
                Button {
                    recoverEntryFromTrash()
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .opacity(currentSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
                }
                .frame(width: currentSwipeFrameWidth)
                .background(Color.blue)
            }
            
            Button {
                switch page {
                case .home:
                    moveToTrash()
                case.trash:
                    showAlertDeleteOneEntry = true
                }
                
            } label: {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(currentSwipeFrameWidth > swipeOptionsWidth / 2 ? 1 : 0)
            }
            .frame(width: currentSwipeFrameWidth)
            .background(Color.red)
            .alert(isPresented: $showAlertDeleteOneEntry) {
                Alert(title: Text("Delete this entry?"), primaryButton: .destructive(Text("Delete"), action: {
                    deleteEntryFromTrash()
                }), secondaryButton: .cancel() {
                    currentSwipeFrameWidth = 0
                    
                })
            }
        }
        .cornerRadius(15)
        .animation(.spring())
        .onChange(of: showingSelection) { _ in
            currentSwipeFrameWidth = 0
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
            if value.translation.width < 0 {
                if value.translation.width < -swipeOptionsWidth {
                    currentSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentSwipeFrameWidth = -value.translation.width
                }
            } else if value.translation.width > 0 && currentSwipeFrameWidth == swipeOptionsWidth {
                currentSwipeFrameWidth = 0
            }
        }
    }
    
    private func swipeOnEnded(value: DragGesture.Value) {
        if !showingSelection {
            if value.translation.width < 0 {
                if value.translation.width < -swipeOptionsWidth {
                    currentSwipeFrameWidth = swipeOptionsWidth
                } else {
                    currentSwipeFrameWidth = 0
                }
            } else {
                currentSwipeFrameWidth = 0
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
