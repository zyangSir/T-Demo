//
//  TDCommonDefine.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/17.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit

/********************** 便利函数(代替OC里的宏) begin *****************/
func TDStoryBoard(fileName: String) -> UIStoryboard {
    return UIStoryboard(name: fileName, bundle: nil)
}

func TDMainStoryBoard() -> UIStoryboard {
    return TDStoryBoard(fileName: "Main")
}

func TDLoginStoryBoard() -> UIStoryboard {
    return TDStoryBoard(fileName: "Login")
}

/********************** 便利函数(代替OC里的宏) end   *****************/

class TDCommonDefine: NSObject {

}
