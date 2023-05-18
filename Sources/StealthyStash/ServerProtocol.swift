#if canImport(Security)
  import Security
#endif

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

  #if canImport(Security)
    private static let spMap: [ServerProtocol: CFString] = .init(
      uniqueKeysWithValues: cfStringMap.map { ($0.value, $0.key) }
    )

    private static let cfStringMap: [CFString: ServerProtocol] = [
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

    public var cfValue: CFString {
      Self.spMap[self]!
    }

    internal init?(number: CFString) {
      guard let value = Self.cfStringMap[number] else {
        return nil
      }
      self = value
    }
  #endif

  public init?(scheme: String) {
    switch scheme {
    case "http":
      self = .http

    default:
      return nil
    }
  }
}
