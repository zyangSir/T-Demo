// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "19972d966efb3e9d7e71bf85e2f909ff"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TUser.self)
  }
}