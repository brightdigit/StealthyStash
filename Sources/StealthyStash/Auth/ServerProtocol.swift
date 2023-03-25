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

  init?(number: CFString) {
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
