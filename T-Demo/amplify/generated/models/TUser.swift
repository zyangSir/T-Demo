// swiftlint:disable all
import Amplify
import Foundation

public struct TUser: Model {
  public let id: String
  public var nickName: String?
  public var account: String
  public var signature: String?
  public var token: String?
  public var email: String?
  public var priority: Priority?
  public var description: String?
  
  public init(id: String = UUID().uuidString,
      nickName: String? = nil,
      account: String,
      signature: String? = nil,
      token: String? = nil,
      email: String? = nil,
      priority: Priority? = nil,
      description: String? = nil) {
      self.id = id
      self.nickName = nickName
      self.account = account
      self.signature = signature
      self.token = token
      self.email = email
      self.priority = priority
      self.description = description
  }
}