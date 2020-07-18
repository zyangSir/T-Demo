//
//  TDUser.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/17.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit

enum TDAccounType {
    case ACC_TYPE_AWS
    case ACC_TYPE_FACEBOOK
}

class TDUser: NSObject {
    var info: TUser?
    ///默认是AWS登录
    var accType: TDAccounType = .ACC_TYPE_AWS
    var fbToken: AccessToken?

    
}
