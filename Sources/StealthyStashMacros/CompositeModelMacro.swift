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
    enum PropertyType : String{
      case internet
      case generic
    }
    internal init(propertiesDataToken: TokenSyntax, propertiesPropertyToken: TokenSyntax, updateToken: TokenSyntax, previousToken: TokenSyntax, newToken: TokenSyntax, propertyToken: TokenSyntax, propertyType : PropertyType = .generic) {
      self.propertiesDataToken = propertiesDataToken
      self.propertiesPropertyToken = propertiesPropertyToken
      self.updateToken = updateToken
      self.previousToken = previousToken
      self.newToken = newToken
      self.propertyToken = propertyToken
      self.propertyType = propertyType
    }
    

    
    let propertiesDataToken : TokenSyntax
    let propertiesPropertyToken : TokenSyntax
    let updateToken : TokenSyntax
    let previousToken : TokenSyntax
    let newToken : TokenSyntax
    let propertyToken : TokenSyntax
    let propertyType: PropertyType
    
    init (syntax : TokenSyntax, attributes: [AttributeSyntax], uniqueID : @escaping @Sendable (String) -> TokenSyntax) {
      let previousToken = uniqueID("previous")
let newToken =  uniqueID("new")
      let updateToken = uniqueID("update")
      self.init(propertiesDataToken: uniqueID("propertyData"), propertiesPropertyToken: uniqueID("property") , updateToken: updateToken, previousToken: previousToken, newToken: newToken, propertyToken: syntax)
    }
    
    
    func syntax () -> String {
      """
      let \(previousToken) = previousItem.\(propertyToken).flatMap {
        $0.data(using: .utf8)
      }.map {
        GenericPasswordItem(account: previousItem.account, data: $0)
      }

      let \(newToken) = newItem.\(propertyToken).flatMap {
        $0.data(using: .utf8)
      }.map {
        GenericPasswordItem(account: newItem.account, data: $0)
      }
      """
    }
    
    func updateSyntax () -> String {
      """
      let \(updateToken) = StealthyPropertyUpdate(
        previousProperty: \(previousToken),
        newProperty: \(newToken)
      )
"""
    }
    
    func propertiesSyntax () -> String {
      """
      let \(propertiesDataToken) = model.\(propertyToken).flatMap {
        $0.data(using: .utf8)
      }

      let \(propertiesPropertyToken): AnyStealthyProperty = .init(
        property: GenericPasswordItem(
          account: model.account,
          data: \(propertiesDataToken) ?? .init()
        )
      )
"""
    }
    
    func queryPairString () -> String {
      """
      "\(self.propertyToken)": TypeQuery(type: .\(self.propertyType))
      """
    }
  }
  
  public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
    guard let structDecl = declaration.as(StructDeclSyntax.self) else {
      throw CustomError.message("Type must be struct.")
    }
    
    let members : [(TokenSyntax, [AttributeSyntax])] = structDecl.memberBlock.members.flatMap { syntax -> [(TokenSyntax, [AttributeSyntax])] in
      guard let variable = syntax.decl.as(VariableDeclSyntax.self) else {
        return []
      }
      let attributes = variable.attributes.compactMap { element -> AttributeSyntax? in
        guard case let .attribute( attribute) = element else {
          return nil
        }
        return attribute
      }
      return variable.bindings.compactMap { syntax in
        syntax.pattern.as(IdentifierPatternSyntax.self)?.identifier.trimmed
      }.map { token in
        (token, attributes)
      }
    }
      .filter{ $0.0.text != "account" }
      
    let updates = members.map{
      StealthyPropertyUpdateSyntax(syntax: $0.0, attributes: $0.1, uniqueID: context.makeUniqueName(_:))
    }
    
    let syntaxStrings = updates.map{$0.syntax()}.joined(separator: "\n")
    let updateStrings = updates.map{$0.updateSyntax()}.joined(separator: "\n")
    let propertiesStrings = updates.map{$0.propertiesSyntax()}.joined(separator: "\n")
    //context.makeUniqueName(<#T##name: String##String#>)
//    let sample =
//    """
//    let previousTokenData = previousItem.token.flatMap {
//      $0.data(using: .utf8)
//    }.map {
//      GenericPasswordItem(account: previousItem.account, data: $0)
//    }
//
//    let newTokenData = newItem.token.flatMap {
//      $0.data(using: .utf8)
//    }.map {
//      GenericPasswordItem(account: newItem.account, data: $0)
//    }
//    """
    
    
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

      \(raw: syntaxStrings)

      \(raw: updateStrings)
      return [\(raw: updates.map{$0.updateToken.text}.joined(separator: ","))]
    }

    static func properties(
      from model: \(typeName),
      for _: ModelOperation
    ) -> [AnyStealthyProperty] {
      \(raw: propertiesStrings)

      return [\(raw: updates.map{$0.propertiesPropertyToken.text}.joined(separator: ","))]
    }

    static func queries(from _: Void) -> [String: Query] {
      [
        \(raw: updates.map{$0.queryPairString()}.joined(separator: ","))
      ]
    }

    static func model(
      from properties: [String: [AnyStealthyProperty]]
    ) throws -> \(typeName)? {
      return dictionary(
for:
        [\(raw: updates.map{"\"\($0.propertyToken)\""}.joined(separator: ","))],
  from: properties).flatMap(\(typeName).init(properties:))
//      for internet in properties["password"] ?? [] {
//        for generic in properties["token"] ?? [] {
//          if internet.account == generic.account {
//            return .init(
//              account: internet.account,
//              password: internet.dataString,
//              token: generic.dataString
//            )
//          }
//        }
//      }
//      let properties = properties.values.flatMap { $0 }.enumerated().sorted { lhs, rhs in
//        if lhs.element.propertyType == rhs.element.propertyType {
//          return lhs.offset < rhs.offset
//        } else {
//          return lhs.element.propertyType == .internet
//        }
//      }.map(\\.element)
//
//      guard let account = properties.map(\\.account).first else {
//        return nil
//      }
//      let password = properties
//        .first { $0.propertyType == .internet }?
//        .data
//      let token = properties.first {
//        $0.propertyType == .generic && $0.account == account
//      }?.data
//
//      return \(typeName)(
//        account: account,
//        password: password?.string(),
//        token: token?.string()
//      )
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


