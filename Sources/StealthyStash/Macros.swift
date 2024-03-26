//
//  File.swift
//  
//
//  Created by Leo Dion on 3/25/24.
//

import Foundation



@attached(member, names: named(QueryBuilder))
@attached(extension, conformances: StealthyModel)
public macro StealthyModel() = #externalMacro(module: "StealthyStashMacros", type: "StealthyModelMacro")
