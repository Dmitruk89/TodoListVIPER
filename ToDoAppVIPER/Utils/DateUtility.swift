//
//  DateUtility.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 01.12.25.
//


import Foundation

struct DateUtility {
    
    private static let shortDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd/yy"
        return df
    }()
    
    static func formatShortDate(_ date: Date) -> String {
        return shortDateFormatter.string(from: date)
    }
}
