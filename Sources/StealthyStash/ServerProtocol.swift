#if canImport(Security)
  public import Security
#endif

/// Denotes the item's protocol.
public enum ServerProtocol: String, Sendable {
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
    private static let cfStringMap: [String: ServerProtocol] = [
      kSecAttrProtocolFTP as String: .ftp,
      kSecAttrProtocolFTPAccount as String: .ftpaccount,
      kSecAttrProtocolHTTP as String: .http,
      kSecAttrProtocolIRC as String: .irc,
      kSecAttrProtocolNNTP as String: .nntp,
      kSecAttrProtocolPOP3 as String: .pop3,
      kSecAttrProtocolSMTP as String: .smtp,
      kSecAttrProtocolSOCKS as String: .socks,
      kSecAttrProtocolIMAP as String: .imap,
      kSecAttrProtocolLDAP as String: .ldap,
      kSecAttrProtocolAppleTalk as String: .appletalk,
      kSecAttrProtocolAFP as String: .afp,
      kSecAttrProtocolTelnet as String: .telnet,
      kSecAttrProtocolSSH as String: .ssh,
      kSecAttrProtocolFTPS as String: .ftps,
      kSecAttrProtocolHTTPS as String: .https,
      kSecAttrProtocolHTTPProxy as String: .httpproxy,
      kSecAttrProtocolHTTPSProxy as String: .httpsproxy,
      kSecAttrProtocolFTPProxy as String: .ftpproxy,
      kSecAttrProtocolSMB as String: .smb,
      kSecAttrProtocolRTSP as String: .rtsp,
      kSecAttrProtocolRTSPProxy as String: .rtspproxy,
      kSecAttrProtocolDAAP as String: .daap,
      kSecAttrProtocolEPPC as String: .eppc,
      kSecAttrProtocolIPP as String: .ipp,
      kSecAttrProtocolNNTPS as String: .nntps,
      kSecAttrProtocolLDAPS as String: .ldaps,
      kSecAttrProtocolTelnetS as String: .telnets,
      kSecAttrProtocolIMAPS as String: .imaps,
      kSecAttrProtocolIRCS as String: .ircs,
      kSecAttrProtocolPOP3S as String: .pop3s,
    ]

    private static let spMap: [ServerProtocol: String] = .init(
      uniqueKeysWithValues: cfStringMap.map { ($0.value, $0.key) }
    )

    internal var cfValue: String {
      Self.spMap[self]!
    }

    internal init?(number: String) {
      guard let value = Self.cfStringMap[number] else {
        return nil
      }
      self = value
    }

    internal init?(number: CFString) {
      self.init(number: number as String)
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
