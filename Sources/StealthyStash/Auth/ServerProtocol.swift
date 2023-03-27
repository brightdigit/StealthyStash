import Security

public enum ServerProtocol: String {
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

  public init?(scheme: String) {
    switch scheme {
    case "http": self = .http
    default: return nil
    }
  }

  var cfValue: CFString {
    switch self {
    case .ftp: return kSecAttrProtocolFTP
    case .ftpaccount: return kSecAttrProtocolFTPAccount
    case .http: return kSecAttrProtocolHTTP
    case .irc: return kSecAttrProtocolIRC
    case .nntp: return kSecAttrProtocolNNTP
    case .pop3: return kSecAttrProtocolPOP3
    case .smtp: return kSecAttrProtocolSMTP
    case .socks: return kSecAttrProtocolSOCKS
    case .imap: return kSecAttrProtocolIMAP
    case .ldap: return kSecAttrProtocolLDAP
    case .appletalk: return kSecAttrProtocolAppleTalk
    case .afp: return kSecAttrProtocolAFP
    case .telnet: return kSecAttrProtocolTelnet
    case .ssh: return kSecAttrProtocolSSH
    case .ftps: return kSecAttrProtocolFTPS
    case .https: return kSecAttrProtocolHTTPS
    case .httpproxy: return kSecAttrProtocolHTTPProxy
    case .httpsproxy: return kSecAttrProtocolHTTPSProxy
    case .ftpproxy: return kSecAttrProtocolFTPProxy
    case .smb: return kSecAttrProtocolSMB
    case .rtsp: return kSecAttrProtocolRTSP
    case .rtspproxy: return kSecAttrProtocolRTSPProxy
    case .daap: return kSecAttrProtocolDAAP
    case .eppc: return kSecAttrProtocolEPPC
    case .ipp: return kSecAttrProtocolIPP
    case .nntps: return kSecAttrProtocolNNTPS
    case .ldaps: return kSecAttrProtocolLDAPS
    case .telnets: return kSecAttrProtocolTelnetS
    case .imaps: return kSecAttrProtocolIMAPS
    case .ircs: return kSecAttrProtocolIRCS
    case .pop3s: return kSecAttrProtocolPOP3S
    }
  }

  static let cfStringMap: [CFString: ServerProtocol] = [
    kSecAttrProtocolFTP: .ftp,
    kSecAttrProtocolFTPAccount: .ftpaccount,
    kSecAttrProtocolHTTP: .http,
    kSecAttrProtocolIRC: .irc,
    kSecAttrProtocolNNTP: .nntp,
    kSecAttrProtocolPOP3: .pop3,
    kSecAttrProtocolSMTP: .smtp,
    kSecAttrProtocolSOCKS: .socks,
    kSecAttrProtocolIMAP: .imap,
    kSecAttrProtocolLDAP: .ldap,
    kSecAttrProtocolAppleTalk: .appletalk,
    kSecAttrProtocolAFP: .afp,
    kSecAttrProtocolTelnet: .telnet,
    kSecAttrProtocolSSH: .ssh,
    kSecAttrProtocolFTPS: .ftps,
    kSecAttrProtocolHTTPS: .https,
    kSecAttrProtocolHTTPProxy: .httpproxy,
    kSecAttrProtocolHTTPSProxy: .httpsproxy,
    kSecAttrProtocolFTPProxy: .ftpproxy,
    kSecAttrProtocolSMB: .smb,
    kSecAttrProtocolRTSP: .rtsp,
    kSecAttrProtocolRTSPProxy: .rtspproxy,
    kSecAttrProtocolDAAP: .daap,
    kSecAttrProtocolEPPC: .eppc,
    kSecAttrProtocolIPP: .ipp,
    kSecAttrProtocolNNTPS: .nntps,
    kSecAttrProtocolLDAPS: .ldaps,
    kSecAttrProtocolTelnetS: .telnets,
    kSecAttrProtocolIMAPS: .imaps,
    kSecAttrProtocolIRCS: .ircs,
    kSecAttrProtocolPOP3S: .pop3s
  ]

  init?(number: CFString) {
    guard let value = Self.cfStringMap[number] else {
      return nil
    }
    self = value
  }
}
