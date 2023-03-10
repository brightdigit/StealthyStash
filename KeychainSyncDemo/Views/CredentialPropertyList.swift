//
//  InternetPasswordList.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import SwiftUI

struct CredentialPropertyList: View {
  let properties : [AnySecretProperty]
    var body: some View {
      #if os(iOS) || os(watchOS)
      List(properties)
      { item in
        NavigationLink(value: item) {
          HStack{
            #if !os(watchOS)
            Image(systemName: item.propertyType.sfSymbolName)
            #endif
            Text(item.account)
            Spacer()
            Text(item.dataString).bold()
          }.lineLimit(1)
          
        }
      }.accessibilityIdentifier("propertyList")
      #else
      Table(properties) {
        TableColumn("") { item in
          HStack{
            Button("Edit") {
              
            }
            Button("Delete") {
              
            }
          }
        }
        TableColumn("Account", value: \.account)
        TableColumn("Data", value: \.dataString)
      }
      #endif
    }
}

struct CredentialPropertyList_Previews: PreviewProvider {
    static var previews: some View {
      CredentialPropertyList(properties: AnySecretProperty.previewCollection)
    }
}
