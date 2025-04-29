//
//  Date+Extensions.swift
//  Gome
//
//  Created by Ryan Williams on 4/28/25.
//

import Foundation

extension Date {
    var onlyDate: Date {
        Calendar.current.startOfDay(for: self)
    }
}
