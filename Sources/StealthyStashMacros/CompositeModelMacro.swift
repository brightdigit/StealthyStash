//
//  File.swift
//  
//
//  Created by Leo Dion on 3/25/24.
//

import SwiftSyntaxMacros
import SwiftSyntax
import SwiftCompilerPlugin

@main
struct MacrosPlugin: CompilerPlugin {
  let providingMacros: [Macro.Type] = [
    StealthyModelMacro.self
  ]
}

enum CustomError: Error { case message(String) }
public struct StealthyModelMacro :  MemberMacro, ExtensionMacro {
  public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
    
    
    [try ExtensionDeclSyntax("extension \(type): StealthyModel {}")]
  }
  
  
  struct StealthyPropertyUpdateSyntax {
    init (syntax : TokenSyntax) {
      
    }
  }
  
  public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.message("Type must be struct.")
    }
    let members : [TokenSyntax] = structDecl.memberBlock.members.flatMap { syntax -> [TokenSyntax] in
      guard let variable = syntax.decl.as(VariableDeclSyntax.self) else {
        return []
      }
      return variable.bindings.compactMap { syntax in
        syntax.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmed
      }
    }.filter{ $0.text != "account" }
  
    //context.makeUniqueName(<#T##name: String##String#>)
    let sample =
    """
    let previousTokenData = previousItem.token.flatMap {
      $0.data(using: .utf8)
    }.map {
      GenericPasswordItem(account: previousItem.account, data: $0)
    }

    let newTokenData = newItem.token.flatMap {
      $0.data(using: .utf8)
    }.map {
      GenericPasswordItem(account: newItem.account, data: $0)
    }
    """
    
    
    let typeName = structDecl.name.trimmed
    let anotherDecl : DeclSyntax
    #if false
    let inheritedType = InheritedTypeSyntax(type: IdentifierTypeSyntax(name: "QueryBuilder"))
    
    
    let newStruct = StructDeclSyntax(name: "NewQueryBuilder" , inheritanceClause: .init(inheritedTypes: .init(arrayLiteral: inheritedType))) {
      FunctionDeclSyntax(modifiers: .init(itemsBuilder: {
        DeclModifierSyntax(name: .keyword(.static))
      }), name: "updates", signature: FunctionSignatureSyntax.init(
      
         parameterClause: .init(parameters: .init(itemsBuilder: {
        [
        FunctionParameterSyntax(firstName: "from", secondName: "previousItem", type: TypeSyntax( "Int"))
        
        ]
         })), returnClause: .init(type: TypeSyntax("[Int]"))))
    }
    anotherDec = .init(newStruct)
    #else
    anotherDecl = """
  struct QueryBuilder: ModelQueryBuilder {
    static func updates(
      from previousItem: \(typeName),
      to newItem: \(typeName)
    ) -> [StealthyPropertyUpdate] {
//      let newPasswordData = newItem.password.flatMap {
//        $0.data(using: .utf8)
//      }.map {
//        InternetPasswordItem(account: newItem.account, data: $0)
//      }
//
//      let oldPasswordData = previousItem.password.flatMap {
//        $0.data(using: .utf8)
//      }.map {
//        InternetPasswordItem(account: previousItem.account, data: $0)
//      }

      let previousTokenData = previousItem.token.flatMap {
        $0.data(using: .utf8)
      }.map {
        GenericPasswordItem(account: previousItem.account, data: $0)
      }

      let newTokenData = newItem.token.flatMap {
        $0.data(using: .utf8)
      }.map {
        GenericPasswordItem(account: newItem.account, data: $0)
      }

      let passwordUpdate = StealthyPropertyUpdate(
        previousProperty: oldPasswordData,
        newProperty: newPasswordData
      )
      let tokenUpdate = StealthyPropertyUpdate(
        previousProperty: previousTokenData,
        newProperty: newTokenData
      )
      return [passwordUpdate, tokenUpdate]
    }

    static func properties(
      from model: \(typeName),
      for _: ModelOperation
    ) -> [AnyStealthyProperty] {
      let passwordData = model.password.flatMap {
        $0.data(using: .utf8)
      }

      let passwordProperty: AnyStealthyProperty = .init(
        property: InternetPasswordItem(
          account: model.account,
          data: passwordData ?? .init()
        )
      )

      let tokenData = model.token.flatMap {
        $0.data(using: .utf8)
      }

      let tokenProperty: AnyStealthyProperty = .init(
        property: GenericPasswordItem(
          account: model.account,
          data: tokenData ?? .init()
        )
      )

      return [passwordProperty, tokenProperty]
    }

    static func queries(from _: Void) -> [String: Query] {
      [
        "password": TypeQuery(type: .internet),
        "token": TypeQuery(type: .generic)
      ]
    }

    static func model(
      from properties: [String: [AnyStealthyProperty]]
    ) throws -> \(typeName)? {
      for internet in properties["password"] ?? [] {
        for generic in properties["token"] ?? [] {
          if internet.account == generic.account {
            return .init(
              account: internet.account,
              password: internet.dataString,
              token: generic.dataString
            )
          }
        }
      }
      let properties = properties.values.flatMap { $0 }.enumerated().sorted { lhs, rhs in
        if lhs.element.propertyType == rhs.element.propertyType {
          return lhs.offset < rhs.offset
        } else {
          return lhs.element.propertyType == .internet
        }
      }.map(\\.element)

      guard let account = properties.map(\\.account).first else {
        return nil
      }
      let password = properties
        .first { $0.propertyType == .internet }?
        .data
      let token = properties.first {
        $0.propertyType == .generic && $0.account == account
      }?.data

      return \(typeName)(
        account: account,
        password: password?.string(),
        token: token?.string()
      )
    }

    internal typealias QueryType = Void

        internal typealias StealthyModelType = \(typeName)
  }
"""
    #endif
    return [
      anotherDecl
    ]
  }

  
  
  
  
}


