//
//  TDUserManager.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/17.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit

class TDUserManager: NSObject {
    
    var user: TDUser?
    
    typealias loginDoneBlock = (_ success:Bool, _ err: Error, _ msg: String)->Void
    
    func login(acc: String!, psw: String!, type: TDAccounType, done: loginDoneBlock) {
        user = TDUser()
        user?.accType = type;
        
        if type == .ACC_TYPE_AWS {
            //AWS登录
        }else if type == .ACC_TYPE_FACEBOOK {
            //FACEBOOK登录
        }
    }
    
    func logout(done: loginDoneBlock) {
        //user?.info?.token
        if user?.accType == .ACC_TYPE_AWS {
            //AWS登出
        }else if user?.accType == .ACC_TYPE_FACEBOOK {
            //FACEBOOK登出
        }
    }

}
