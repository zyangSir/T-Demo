//
//  TVideoInfo.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/13.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit

class TVideoInfo: NSObject {
    var albumURL: URL?
    var streamURL: URL?
    var resolution: CGSize? // 清晰度
    
    init(albumPath: String?, streamPath: String) {
        
        albumURL = URL(string: albumPath ?? "")
        streamURL = URL(string: streamPath )
        
    }
}
