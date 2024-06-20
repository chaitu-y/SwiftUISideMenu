//
//  SideMenuView.swift
//  SideMenu
//
//  Created by HeadsUp on 6/12/24.
//

import SwiftUI

extension Notification.Name {
    /// Post on main thread when side view should be shown. If already visible does nothing.
    static let showSideView = NSNotification.Name("ShowSideView")
    
    /// Post on main thread when side view should be hidden. If already hidden does nothing.
    static let hideSideView = NSNotification.Name("HideSideView")
}

struct SideMenuView<SideView: View, MainView: View>: View {
    
    let sideView: SideView
    let mainView: MainView
    let sideMenuWidth: CGFloat
    let bufferOffset = 100.0
    @State private var dragAmount: CGFloat
    
    init(sideMenuWidth: CGFloat, @ViewBuilder sidebar: ()->SideView, @ViewBuilder content: ()->MainView) {
        self.sideMenuWidth = sideMenuWidth
        self.dragAmount = -sideMenuWidth - bufferOffset
        sideView = sidebar()
        mainView = content()
    }
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            mainView
            if dragAmount > -sideMenuWidth - bufferOffset {
                Color(.darkGray)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.6 + (dragAmount/sideMenuWidth))
                    .onTapGesture {
                        if dragAmount == 0 {
                            dragAmount = -sideMenuWidth - bufferOffset
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged {
                                if $0.translation.width <= 0 && $0.translation.width > -sideMenuWidth - bufferOffset  {
                                    dragAmount = $0.translation.width
                                }
                            }
                            .onEnded({ value in
                                if dragAmount >= -sideMenuWidth/2 {
                                    dragAmount = 0
                                }
                                else {
                                    dragAmount = -sideMenuWidth - bufferOffset
                                }
                            })
                    )
            }
            
            sideView
            .frame(width: sideMenuWidth)
            .padding(.leading, 0)
            .offset(x: dragAmount)
            .gesture(
                DragGesture()
                    .onChanged {
                        if $0.translation.width > 0 {
                            return
                        }
                        else {
                            dragAmount = $0.translation.width
                        }
                    }
                    .onEnded({ value in
                        if dragAmount > -sideMenuWidth/2 {
                            dragAmount = 0
                        }
                        else {
                            dragAmount = -sideMenuWidth - bufferOffset
                        }
                    })
            )
            .animation(.spring, value: dragAmount)
        }
        .onReceive(NotificationCenter.default.publisher(for: .showSideView, object: nil)) { _ in
            dragAmount = 0
        }
        .onReceive(NotificationCenter.default.publisher(for: .hideSideView, object: nil)) { _ in
            dragAmount = -sideMenuWidth - 60.0
        }
    }
}
