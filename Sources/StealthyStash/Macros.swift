//
//  File.swift
//  
//
//  Created by Leo Dion on 3/25/24.
//

import Foundation



@attached(extension, conformances: StealthyModel) public macro StealthyModelMacro() = #externalMacro(module: "StealthyStashMacros", type: "StealthyModelMacro")
