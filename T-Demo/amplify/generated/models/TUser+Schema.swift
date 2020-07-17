// swiftlint:disable all
import Amplify
import Foundation

extension TUser {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case nickName
    case account
    case signature
    case token
    case email
    case priority
    case description
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let tUser = TUser.keys
    
    model.pluralName = "TUsers"
    
    model.fields(
      .id(),
      .field(tUser.nickName, is: .optional, ofType: .string),
      .field(tUser.account, is: .required, ofType: .string),
      .field(tUser.signature, is: .optional, ofType: .string),
      .field(tUser.token, is: .optional, ofType: .string),
      .field(tUser.email, is: .optional, ofType: .string),
      .field(tUser.priority, is: .optional, ofType: .enum(type: Priority.self)),
      .field(tUser.description, is: .optional, ofType: .string)
    )
    }
}