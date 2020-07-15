//
//  TVideoDetailViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import JPVideoPlayer

class TVideoDetailViewController: TBaseViewController {
    
    ///视频幕布图层
    @IBOutlet weak var dispView: UIImageView!

    ///视频信息
    var videoInfo: TVideoInfo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dispView.yy_setImage(with: videoInfo?.albumURL, options: .progressiveBlur)
        
        if (videoInfo?.streamURL?.absoluteString.hasSuffix(".ts"))! {
            //ts文件需要先下载到本地，转码成MP4
            
        }else {
            playVideoLater()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // stop play video
        self.dispView.jp_stopPlay()
    }
    
    ///1.5s后 开始循环播放视频
    func playVideoLater() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.beginPlayVideo()
        }
    }
    
    func beginPlayVideo() {
        self.dispView.jp_playVideo(with: (self.videoInfo?.streamURL)!, options: JPVideoPlayerOptions(rawValue: 0), configuration: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
