//
//  InternetPasswordList.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import SwiftUI

struct InternetPasswordList: View {
  let internetPasswords : [InternetPasswordItem]
    var body: some View {
      List(internetPasswords)
      { item in
        NavigationLink(value: item) {
          HStack{
            Text(item.account)
            Spacer()
            Text(item.dataString).bold()
          }
          
        }
      }
    }
}

struct InternetPasswordList_Previews: PreviewProvider {
    static var previews: some View {
      InternetPasswordList(internetPasswords: InternetPasswordItem.previewCollection)
    }
}
