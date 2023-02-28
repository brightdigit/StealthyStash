//
//  InternetPasswordRootView.swift
//  KeychainSyncDemo
//
//  Created by Leo Dion on 2/24/23.
//

import SwiftUI
import Combine
import FloxBxAuth

extension Int {
  func trimZero () -> Int? {
    return self == 0 ? nil : self
  }
}
public enum ServerProtocol : String {
  case ftp
  case ftpaccount
  case http
  case irc
  case nntp
  case pop3
  case smtp
  case socks
  case imap
  case ldap
  case appletalk
  case afp
  case telnet
  case ssh
  case ftps
  case https
  case httpproxy
  case httpsproxy
  case ftpproxy
  case smb
  case rtsp
  case rtspproxy
  case daap
  case eppc
  case ipp
  case nntps
  case ldaps
  case telnets
  case imaps
  case ircs
  case pop3s
  
  init?(scheme : String) {
    switch scheme {
    case "http": self = .http
    default: return nil
    }
  }
  init?(number : CFString) {
    switch number {
    case kSecAttrProtocolFTP: self = .ftp
      
    case kSecAttrProtocolFTPAccount: self = .ftpaccount
      
    case kSecAttrProtocolHTTP: self = .http

    case kSecAttrProtocolIRC: self = .irc

    case kSecAttrProtocolNNTP: self = .nntp

    case kSecAttrProtocolPOP3: self = .pop3

    case kSecAttrProtocolSMTP: self = .smtp

    case kSecAttrProtocolSOCKS: self = .socks

    case kSecAttrProtocolIMAP: self = .imap

    case kSecAttrProtocolLDAP: self = .ldap

    case kSecAttrProtocolAppleTalk: self = .appletalk

    case kSecAttrProtocolAFP: self = .afp

    case kSecAttrProtocolTelnet: self = .telnet

    case kSecAttrProtocolSSH: self = .ssh

    case kSecAttrProtocolFTPS: self = .ftps

    case kSecAttrProtocolHTTPS: self = .https

    case kSecAttrProtocolHTTPProxy: self = .httpproxy

    case kSecAttrProtocolHTTPSProxy: self = .httpsproxy

    case kSecAttrProtocolFTPProxy: self = .ftpproxy

    case kSecAttrProtocolSMB: self = .smb

    case kSecAttrProtocolRTSP: self = .rtsp

    case kSecAttrProtocolRTSPProxy: self = .rtspproxy

    case kSecAttrProtocolDAAP: self = .daap

    case kSecAttrProtocolEPPC: self = .eppc

    case kSecAttrProtocolIPP: self = .ipp

    case kSecAttrProtocolNNTPS: self = .nntps

    case kSecAttrProtocolLDAPS: self = .ldaps

    case kSecAttrProtocolTelnetS: self = .telnets

    case kSecAttrProtocolIMAPS: self = .imaps

    case kSecAttrProtocolIRCS: self = .ircs

    case kSecAttrProtocolPOP3S: self = .pop3s
    default:
      return nil
    }
  }
}
public typealias AuthenticationType = String

extension Dictionary {
  enum MissingValueError<Output>: Error {
    case missingKey(Key)
    case mismatchType(Value)


    
  }

  func requireOptional<Output>(_ key: CFString) throws -> Output? where Key == String {
    try self.requireOptional(key as String)
  }
  
  func requireOptional<Output>(_ key: Key) throws -> Output? {
    try requireOptional(key, as: Output.self)
  }

  private func requireOptional<Output>(_ key: Key, as _: Output.Type) throws -> Output? {
    guard let value = self[key] else {
      return nil
    }
    guard let value = value as? Output else {
      throw MissingValueError<Output>.mismatchType(value)
    }
    return value
  }

  func require<Output>(_ key: Key) throws -> Output {
    try require(key, as: Output.self)
  }
  
  func require<Output>(_ key: CFString) throws -> Output where Key == String {
    try require(key as String)
  }

  private func require<Output>(_ key: Key, as _: Output.Type) throws -> Output {
    guard let value = self[key] else {
      throw MissingValueError<Output>.missingKey(key)
    }
    guard let value = value as? Output else {
      throw MissingValueError<Output>.mismatchType(value)
    }
    return value
  }
}

public struct InternetPasswordItem : Identifiable, Hashable{
  public var id: String {
    
    [self.account,
    self.server,
     self.protocol?.rawValue,
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
      protocol: data.url?.scheme.flatMap(ServerProtocol.init(scheme:)),
      port: data.url?.port,
      path: data.url?.path,
      isSynchronizable: data.isSynchronizable
    )
  }
}

extension InternetPasswordItem {
  init(dictionary : [String : Any]) throws {
    let account : String = try dictionary.require(kSecAttrAccount)
    let data : Data = try dictionary.require(kSecValueData)
    let accessGroup : String? = try dictionary.requireOptional(kSecAttrAccessGroup)
    let createdAt : Date? = try dictionary.requireOptional(kSecAttrCreationDate)
    let modifiedAt : Date? = try dictionary.requireOptional(kSecAttrModificationDate)
    let description: String? = try dictionary.requireOptional(kSecAttrDescription)
    let type : Int? = try dictionary.requireOptional(kSecAttrType)
    let label : String? = try dictionary.requireOptional(kSecAttrLabel)
    let server : String? = try dictionary.requireOptional(kSecAttrServer)
    let protocolString : CFString? = try dictionary.requireOptional(kSecAttrProtocol)
    let `protocol` : ServerProtocol? = protocolString.flatMap(ServerProtocol.init(number: ))
    //let authenticationType : AuthenticationType? = try dictionary.requireOptional(kSecAttrAuthenticationType)
    let port: Int? = try dictionary.requireOptional(kSecAttrPort)
    let path: String? = try dictionary.requireOptional(kSecAttrPath)
    let isSynchronizable : Bool? = try dictionary.requireOptional(kSecAttrSynchronizable)
    self.init(
      account: account,
      data: data,
      accessGroup: accessGroup,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      description: description,
      type: type?.trimZero(),
      label: label,
      server: server,
      protocol: `protocol`,
      port: port?.trimZero(),
      path: path,
      isSynchronizable: isSynchronizable
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
            InternetPasswordView(repository: self.object.repository, item: item).navigationTitle(item.account)
          }.navigationDestination(isPresented: self.$createNewItem) {
            InternetPasswordView(repository: self.object.repository)
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
