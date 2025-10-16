//
//  InterfaceController.swift
//  Stress
//
//  Created by Claire Kraft on 10/15/25.
//  WatchKit Entry
//


import WatchKit
import Foundation
import SwiftUI

// Wraps a SwiftUI view for the watch interface
class InterfaceController: WKHostingController<WatchMenuView> {
    override var body: WatchMenuView {
        WatchMenuView()
    }
}
