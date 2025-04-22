//
//  Item.swift
//  Gome
//
//  Created by Ryan Williams on 4/22/25.
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
