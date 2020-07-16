//
//  TVideoDetailViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import JPVideoPlayer
import mobileffmpeg
import SVProgressHUD

class TVideoDetailViewController: TBaseViewController {
    
    ///视频幕布图层
    @IBOutlet weak var dispView: UIImageView!

    ///视频信息
    var videoInfo: TVideoInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dispView.yy_setImage(with: videoInfo?.albumURL, options: .progressiveBlur)
        
        self.title = videoInfo?.srcType
        
        if (videoInfo?.streamURL?.absoluteString.hasSuffix(".ts"))! {
            //ts文件需要先下载到本地，转码成MP4
            convertTsVideo(tsUrl: (videoInfo?.streamURL)!) { (mp4Url) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    SVProgressHUD.dismiss()
                    self.beginPlayVideo(videoUrl: mp4Url)
                }
            }
            
        }else {
            playVideoLater(videoUrl: (videoInfo?.streamURL)!)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // stop play video
        self.dispView.jp_stopPlay()
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Ctrl
    
    ///1.5s后 开始循环播放视频
    func playVideoLater(videoUrl: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.beginPlayVideo(videoUrl: videoUrl)
        }
    }
    
    func beginPlayVideo(videoUrl: URL) {
        self.dispView.jp_playVideo(with: videoUrl, options: JPVideoPlayerOptions(rawValue: 0), configuration: nil)
    }
    
    // MARK: - Data Convert
    // 视频数据转换
    func convertTsVideo(tsUrl: URL, callBack: @escaping (_ mp4Url: URL)->Void) {
        
        //如果之前已经转码并缓存过，则直接返回已有 Mp4 url
        let tsUrlPath = tsUrl.absoluteString
        let lastBackSlashRange = tsUrlPath.range(of: "/", options: .backwards)
        if lastBackSlashRange!.isEmpty {
            return
        }
        
        let stIndex = tsUrlPath.index(after: lastBackSlashRange!.lowerBound)
        let edIndex = tsUrlPath.index(tsUrlPath.endIndex, offsetBy: -3)//去掉 ‘.ts’ 尾部
        let mp4fileName = String(tsUrlPath[stIndex..<edIndex]) + ".mp4"
        
        if self.isMp4FileCached(mp4fileName: mp4fileName) {
            let mp4Url = self.genUrlWithMp4FileName(mp4fileName)
            callBack(mp4Url)
        } else {
            //开始转码, 转个Loading圈
            let tsFileName = String(tsUrlPath[stIndex..<edIndex]) + ".ts"
            let tsFilePath = ZSFilePather.commonCacheDirPath() + "/" + tsFileName
            SVProgressHUD.show(withStatus: "好戏马上开始")
            
            //此处涉及数据下载，视频格式转换，因此要放到子线程
            DispatchQueue.global(qos: .userInitiated).async {
                //先下载ts文件
                do {
                    let tsData = try Data(contentsOf: tsUrl)
                    try tsData.write(to: URL(fileURLWithPath: tsFilePath))
                } catch let err as NSError {
                    print("ts文件下载失败: \(err)")
                    return
                }
                
                //转成mp4
                let mp4FilePath = ZSFilePather.commonCacheDirPath() + "/" + mp4fileName
                //@"-i file1.mp4 -c:v mpeg4 file2.mp4"
                let execStr = String("-i \(tsFilePath) -c:v mpeg4 \(mp4FilePath)")
                let ret = MobileFFmpeg.execute(execStr)
                if ret == RETURN_CODE_SUCCESS {
                    //转码成功, 同时mp4文件也有了
                    //成功后调用播放回调
                    let mp4Url = self.genUrlWithMp4FileName(mp4fileName)
                    callBack(mp4Url)
                } else {
                    //转码失败
                    print("fail to convert .ts file into .mp4!!!")
                    return
                }
            }
        }
    }
    
    func isMp4FileCached(mp4fileName: String) -> Bool{
        let mp4FilePath = ZSFilePather.commonCacheDirPath() + "/" + mp4fileName
        if FileManager.default.fileExists(atPath: mp4FilePath) {
            return true
        }
        
        return false
    }
    
    func genUrlWithMp4FileName(_ fileName: String) -> URL {
        let mp4FilePath = ZSFilePather.commonCacheDirPath() + "/" + fileName
        return URL(fileURLWithPath: mp4FilePath)
    }

}
