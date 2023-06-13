//
//  PhoneView.swift
//  StashSyncKit
//
//  Created by Leo Dion on 6/13/23.
//

import SwiftUI
import StealthyStash

public struct PhoneView: View {
  public init(oldGeneric: GenericPasswordItem? = nil, oldInternet: InternetPasswordItem? = nil, generic: String = "", internet: String = "", errorDescription: String? = nil) {
    self.oldGeneric = oldGeneric
    self.oldInternet = oldInternet
    self.generic = generic
    self.internet = internet
    self.errorDescription = errorDescription
  }
  
  static let defaultName = "StashSync"
  let repository = KeychainRepository(defaultServiceName: "StashSync", defaultServerName: "StashSync", defaultAccessGroup: "MLT7M394S7.com.brightdigit.StashSync")
  
  
  @State var oldGeneric : GenericPasswordItem?
  @State var oldInternet : InternetPasswordItem?
  
  @State var generic : String = ""
  @State var internet : String = ""
  @State var errorDescription : String?
  
  public  func load () {
    do {
      if let genericItem = try repository.query(TypeQuery(type: .generic)).first {
        self.oldGeneric = genericItem.property as? GenericPasswordItem
        self.generic = String(data: genericItem.data , encoding: .utf8) ?? ""
      }
      
      if let internetItem = try repository.query(TypeQuery(type: .internet)).first {
        self.oldInternet = internetItem.property as? InternetPasswordItem
        self.internet = String(data: internetItem.data , encoding: .utf8) ?? ""
      }
    } catch {
      self.errorDescription = error.localizedDescription
    }
  }
  
  
  func save () {
    let newGeneric = GenericPasswordItem(account: Self.defaultName, data: self.generic.data(using: .utf8)!, isSynchronizable: .enabled)
    
    let newInternet = InternetPasswordItem(account: Self.defaultName, data: self.internet.data(using: .utf8)!, isSynchronizable: .enabled)
    do{
      if let oldGeneric {
        try repository.update(newGeneric, from: oldGeneric)
      } else {
        try repository.create(.init(property: newGeneric))
      }
      self.oldGeneric = newGeneric
      if let oldInternet {
        try repository.update(newInternet, from: oldInternet)
      } else {
        try repository.create(.init(property: newInternet))
      }
      self.oldInternet = newInternet
    } catch {
      self.errorDescription = error.localizedDescription
    }
  }
  
    public var body: some View {
      VStack {
        TextField("Internet", text: self.$internet)
        TextField("Generic", text: self.$generic)
        HStack{
          Button("Load") {
            self.load()
          }
          Button("Save") {
            self.save()
          }
        }
        if let errorDescription = self.errorDescription {
          Button(action: {
            self.errorDescription = nil
          }, label: {
            Text(errorDescription)
          }).buttonStyle(.borderless)
        }
      }
      .padding().onAppear{
        self.load()
      }
    }
}

#Preview {
    PhoneView(errorDescription: "Test Error")
}
