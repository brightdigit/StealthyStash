//
//  InternetPasswordFormContentView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 3/1/23.
//

import SwiftUI

struct InternetPasswordFormContentView: View {
  @ObservedObject var object : InternetPasswordObject
    var body: some View {
      Section("Account") {
        TextField("account", text: $object.item.account)
      }
      
      Section("Data") {
        TextEditor(text: $object.item.dataString).frame(height: 80.0)
      }
      
      Section("Is Syncronizable") {
        Toggle("Is Set", isOn: $object.item.isSynchronizableSet)
        Toggle("Is Syncronizable", isOn: $object.item.isSynchronizableValue)
      }
      
      Section("Access Group") {
        TextEditor(text: $object.item.accessGroupText).frame(height: 60.0)
      }
      
      Section("Type") {
        Toggle("Set Type", isOn: $object.item.hasType)
        Stepper(value: $object.item.typeValue) {
          Text("\(object.item.typeValue)")
        }
      }
      
      Section("Label") {
        Toggle("Set Label", isOn: $object.item.hasLabel)
        TextField("label", text: $object.item.labelValue)
      }
      
      Section("URL"){
        Text(object.item.url?.description ?? "")
      }
      
      Section("Description") {
        TextEditor(text: $object.item.descriptionText).frame(height: 80.0)
      }
    }
}

struct InternetPasswordFormContentView_Previews: PreviewProvider {
    static var previews: some View {
      InternetPasswordFormContentView(object: InternetPasswordObject(repository: PreviewRepository()))
    }
}
