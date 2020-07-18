//
//  TDUserManager.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/17.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit

let TD_LOGIN_SUCC_NOTIFICATION = NSNotification.Name(rawValue: "TD_LOGIN_SUCC")
let TD_LOGOUT_SUCC_NOTIFICATION = NSNotification.Name(rawValue: "TD_LOGOUT_SUCC")

class TDUserManager: NSObject {
    static let sharedInstance = TDUserManager()
    
    
    var user: TDUser?
    lazy var fbLoginManager: LoginManager = {
        return LoginManager()
    }()
    
    typealias loginDoneBlock = (_ success:Bool, _ err: Error?, _ msg: String)->Void
    
    func tryAutoLogin(done: loginDoneBlock) {
        //账号自动登录相关逻辑比较耗时，因为是demo所以这里省略掉，直接返回自动登录失败，即每次重新打开App都要登录
        done(false, nil, "请重新登录")
    }
    
    func login(acc: String!, psw: String!, type: TDAccounType, done: @escaping loginDoneBlock) {
        user = TDUser()
        user?.accType = type;
        
        if type == .ACC_TYPE_AWS {
            //AWS登录
            
            
        }else if type == .ACC_TYPE_FACEBOOK {
            //FACEBOOK登录
            let nowVC = UIApplication.shared.keyWindow?.rootViewController!
            
            fbLoginManager.logIn(permissions: ["public_profile"], from: nowVC) { (result, err) in
                if result?.token != nil {
                    self.user?.fbToken = result?.token
                    //登录成功了
                    done(true, nil, "登录成功")
                }else if result?.isCancelled ?? false {
                    //取消了登录
                    done(false, nil, "取消了登录")
                }else {
                    //登录失败
                    done(false, nil, "登录失败")
                }
            }
        }
    }
    
    func logout(done: loginDoneBlock?) {
        //user?.info?.token
        if user?.accType == .ACC_TYPE_AWS {
            //AWS登出
        }else if user?.accType == .ACC_TYPE_FACEBOOK {
            //FACEBOOK登出
            fbLoginManager.logOut()
        }
        
        postLogoutSuccNotification()
    }
    
    // MARK: - Notification
    func postLogoutSuccNotification() {
        NotificationCenter.default.post(name: TD_LOGOUT_SUCC_NOTIFICATION, object: nil)
    }

}
