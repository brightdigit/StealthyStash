//
//  InternetPasswordList.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import SwiftUI

struct CredentialPropertyList: View {
  let properties : [AnyCredentialProperty]
    var body: some View {
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
      }
    }
}

struct CredentialPropertyList_Previews: PreviewProvider {
    static var previews: some View {
      CredentialPropertyList(properties: AnyCredentialProperty.previewCollection)
    }
}
