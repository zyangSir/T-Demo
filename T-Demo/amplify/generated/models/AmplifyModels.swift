// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "607e982626fc5af52cf8ccee911de7c3"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TUser.self)
  }
}