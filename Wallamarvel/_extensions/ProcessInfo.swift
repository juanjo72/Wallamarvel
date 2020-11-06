//
//  ProcessInfo.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 06/11/2020.
//

import Foundation

extension ProcessInfo {
    var isAPICallsDebugging: Bool {
        environment["API_CALLS_DEBUG"] == "enable"
    }
    
    var isMemoryDeallocDebugging: Bool {
        environment["MEMORY_DEALLOC_DEBUG"] == "enable"
    }
}
