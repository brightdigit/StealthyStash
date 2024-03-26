//
//  File.swift
//  
//
//  Created by Leo Dion on 3/25/24.
//

import SwiftSyntaxMacros
import StealthyStash
import SwiftSyntax
import SwiftCompilerPlugin

@main
struct MacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StealthyModelMacro.self
  ]
}

public struct StealthyModelMacro :  ExtensionMacro {
  public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
    return try [ .init("test")]
  }
  

  
  
  
  
}


