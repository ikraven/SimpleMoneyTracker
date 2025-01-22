//
//  Item.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 22/1/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
