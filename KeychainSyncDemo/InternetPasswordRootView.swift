//
//  InternetPasswordRootView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import Combine
import FloxBxAuth

public typealias ServerProtocol = String
public typealias AuthenticationType = String

public struct InternetPasswordItem : Identifiable,Hashable {
  public var id: String {
    
    [self.account,
    self.server,
    self.protocol,
    self.authenticationType,
     self.port?.description,
     self.path].compactMap{$0}.joined()
  }
  
  public init(account: String, data: Data, accessGroup: String? = nil, createdAt: Date? = nil, modifiedAt: Date? = nil, description: String? = nil, type: Int? = nil, label: String? = nil, server: String? = nil, `protocol`: ServerProtocol? = nil, authenticationType: AuthenticationType? = nil, port: Int? = nil, path: String? = nil, isSynchronizable: Bool? = nil) {
    self.account = account
    self.data = data
    self.accessGroup = accessGroup
    self.createdAt = createdAt
    self.modifiedAt = modifiedAt
    self.description = description
    self.type = type
    self.label = label
    self.server = server
    self.`protocol` = `protocol`
    self.authenticationType = authenticationType
    self.port = port
    self.path = path
    self.isSynchronizable = isSynchronizable
  }
  
  public let account : String
  public let data : Data
   
  public let accessGroup : String?
  public let createdAt : Date?
  public let modifiedAt : Date?
  public let description: String?
  public let type : Int?
  public let label : String?
  public let server : String?
  public let `protocol` : ServerProtocol?
  public let authenticationType : AuthenticationType?
  public let port: Int?
  public let path: String?
  public let isSynchronizable : Bool?
}

extension InternetPasswordItem {
  public var dataString : String {
    String(data: self.data, encoding: .utf8) ?? ""
  }
}

extension InternetPasswordItem {
  init(data: InternetPasswordData) {
    self.init(
      account: data.account,
      data: data.data.data(using: .utf8)!,
      accessGroup: data.accessGroup,
      createdAt: data.createdAt,
      modifiedAt: data.modifiedAt,
      description: data.description,
      type: data.type,
      label: data.label,
      server: data.url?.host,
      protocol: data.url?.scheme,
      port: data.url?.port,
      path: data.url?.path,
      isSynchronizable: data.isSynchronizable
    )
  }
}

extension InternetPasswordItem {
  init(builder: InternetPasswordItemBuilder) {
    self.init(
      account: builder.account,
      data: builder.data,
      accessGroup: builder.accessGroup,
      createdAt: builder.createdAt,
      modifiedAt: builder.modifiedAt,
      description: builder.description,
      type: builder.type,
      label: builder.label,
      server: builder.server,
      protocol: builder.protocol,
      port: builder.port,
      path: builder.path,
      isSynchronizable: builder.isSynchronizable
    )
  }
}
class PreviewInternetPasswordObject : ObservableObject {
  let internetPasswords : [InternetPasswordItem]
  
  init(internetPasswords: [InternetPasswordItem]) {
    self.internetPasswords = internetPasswords
  }
}

struct Query {
  init (string : String?) {
    
  }
}

class InternetPasswordListObject : ObservableObject {
  internal init(repository: CredentialsRepository, internetPasswords: [InternetPasswordItem]? = nil) {
    self.repository = repository
    self.internetPasswords = internetPasswords
    
    let queryPublisher = self.querySubject
      .map(Query.init)
      .tryMap(self.repository.query)
      .share()
    
    
    queryPublisher
      .map{_ in Optional<Error>.none}
      .catch{Just(Optional<Error>.some($0))}
      .compactMap{ $0 as? KeychainError }
      .receive(on: DispatchQueue.main)
      .assign(to: &self.$lastError)
    
    queryPublisher
      .map(Optional<[InternetPasswordItem]>.some)
      .replaceError(with: nil)
      .receive(on: DispatchQueue.main)
      .print()
      .assign(to: &self.$internetPasswords)
  }
  
  let repository : CredentialsRepository
  @Published var internetPasswords: [InternetPasswordItem]?
  let querySubject  = PassthroughSubject<String?, Never> ()
  @Published var lastError : KeychainError?
  

  func query (_ string: String?) {
    self.querySubject.send(string)
  }
}
struct InternetPasswordRootView: View {
  internal init(repository: CredentialsRepository, internetPasswords: [InternetPasswordItem]? = nil, query: String? = nil, createNewItem: Bool = false) {
    self._object = StateObject(wrappedValue: .init(repository: repository, internetPasswords: internetPasswords))
    self.query = query
    self.createNewItem = createNewItem
  }
  
  @StateObject var object : InternetPasswordListObject
  @State var query : String?
  @State var createNewItem = false
  fileprivate func InternetPasswordList(internetPasswords: [InternetPasswordItem]) -> some View {
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
  
  var body: some View {
      NavigationStack {
        Form{
          Section{
            Button(role: .none) {
              
            } label: {
              if let query {
                HStack{
                  Text(query).italic()
                  Spacer()
                  Image(systemName: "magnifyingglass")
                }
              } else {
                HStack{
                  Text("Query")
                  Spacer()
                  Image(systemName: "magnifyingglass")
                }
              }
              
            }

          }
          Section{
            Group{
              if let internetPasswords = self.object.internetPasswords {
                InternetPasswordList(internetPasswords: internetPasswords)
              } else {
                ProgressView()
              }
            }
            
          } header: {
            HStack{
              Text("account")
              Spacer()
              Text("data")
            }
          }
        }.navigationTitle("Internet Passwords")
          .toolbar {
            Button {
              self.createNewItem = true
            } label: {
              Image(systemName: "plus")
            }
            
          }.navigationDestination(for: InternetPasswordItem.self) { item in
            InternetPasswordView(repository: PreviewRepository(), item: item).navigationTitle(item.account)
          }.navigationDestination(isPresented: self.$createNewItem) {
            InternetPasswordView(repository: PreviewRepository())
          }.onAppear {
            self.object.query(self.query)
          }
      }
    }
}

struct InternetPasswordRootView_Previews: PreviewProvider {
    static var previews: some View {
      InternetPasswordRootView(repository: PreviewRepository(), internetPasswords: InternetPasswordItem.previewCollection)
//      InternetPasswordRootView(object: .init(repository: PreviewRepository(), internetPasswords:
//                                              InternetPasswordItem.previewCollection
//                                            ))
    }
}
