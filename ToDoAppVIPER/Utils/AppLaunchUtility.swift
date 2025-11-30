//
//  AppLaunchUtility.swift
//  ToDoAppVIPER
//
//  Created by Руковичников Дмитрий on 30.11.25.
//


import Foundation

struct AppLaunchUtility {
    
    private static let hasLaunchedBeforeKey = "hasLaunchedBefore"
        // for tests
    static var isFirstLaunchOverride: Bool?
    
    static func isFirstLaunch() -> Bool {
        // test case
        if let overrideValue = isFirstLaunchOverride {
            return overrideValue
        }
        
        // real flow
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: AppLaunchUtility.hasLaunchedBeforeKey)
        
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: AppLaunchUtility.hasLaunchedBeforeKey)
            return true
        }
        
        return false
    }
}
