//
//  TVideoListViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

let PREVIEW_ALBUM_IMG_PATH = "https://s3-ap-southeast-2.amazonaws.com/maji-dev-buckets/images/DDC9C6DF-6986-4772-BA96-27F6EFB8CD94.png"

class TVideoListViewController: TBaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var videoAssetArr = [TVideoInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //runAmplifyTest()
        
        DispatchQueue.global(qos: .background).async {
            self.loadVideoAssets()
        }
    }
    
    func runAmplifyTest() {
        let item = TUser(nickName: "Tom", account: "momo", priority: .high, description: "This is a test")
        
        Amplify.DataStore.save(item) { (result) in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.account)")
                
            case .failure(let err):
                print("Could not save item to datastore: \(err)")
            }
        }
    }
    
    // MARK: - Data load & parse
    func loadVideoAssets() {
        //HLS 视频列表, 加载m3u8文件后解析出视频列表并装入数据源
        let hlsUrlPath = "https://d3ngi64t7aakaf.cloudfront.net/ecea0248-72c2-4c26-a0d7-fa45fefb4653/hls/8A2E394C-008F-48C4-9EBD-47D16BA54E5C.m3u8"
        let hlsPathEncoded = hlsUrlPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let hlsUrlDomain = "https://d3ngi64t7aakaf.cloudfront.net/ecea0248-72c2-4c26-a0d7-fa45fefb4653/hls/"
        var m3u8Str: String?
        do {
            let hlsServerUrl = URL(string: hlsPathEncoded!)
            
            m3u8Str = try String(contentsOf: hlsServerUrl!)
            
            
        } catch {
            let hlsLocalUrl = Bundle.main.url(forResource: "hls1", withExtension: "m3u8")
            do {
                m3u8Str = try String(contentsOf: hlsLocalUrl!)
                print("远端加载失败，尝试启用本地m3u8文件")
            } catch {
                print("m3u8文件加载失败!")
            }
        }
        
        let strArr = m3u8Str!.components(separatedBy: "\n")
        // parse m3u8 video segments, into xxx.ts link url
        for line in strArr {
            if line.hasSuffix(".m3u8") {
                let m3u8FilePath = hlsUrlDomain + line
                //此时路径还是 .m3u8 link，我们要进一步把它转换成 .ts link, 之后就可以用来下载视频数据片段
                let url = URL(string: urlPathEncode(urlPath: m3u8FilePath)!)
                do {
                    let tsFileInfo = try String(contentsOf: url!)
                    let tsFilePathArr = parseTsFileInfo(tsFileInfo)
                    for tsFileName in tsFilePathArr {
                        let tsFilePath = hlsUrlDomain + tsFileName
                        let m3u8Res = TVideoInfo(albumPath: PREVIEW_ALBUM_IMG_PATH, streamPath: tsFilePath)
                        
                        videoAssetArr.append(m3u8Res)
                    }
                    
                } catch let err as NSError {
                    print(err)
                    break;
                }
                
            }
        }
        
        //MP4 视频地址
        let mp4Path = "https://s3-ap-southeast-2.amazonaws.com/maji-dev-buckets/videos/8A2E394C-008F-48C4-9EBD-47D16BA54E5C.mp4"
        //let mp4Path = "https://d3ngi64t7aakaf.cloudfront.net/ecea0248-72c2-4c26-a0d7-fa45fefb4653/hls/8A2E394C-008F-48C4-9EBD-47D16BA54E5C_Ott_Hls_Ts_Avc_Aac_16x9_270x480p_15Hz_0.4Mbps_qvbr_00001.ts"
        
        let mp4Res = TVideoInfo(albumPath: PREVIEW_ALBUM_IMG_PATH, streamPath: urlPathEncode(urlPath: mp4Path)!)
        
        videoAssetArr.append(mp4Res)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parseTsFileInfo(_ tsFileInfo: String) -> [String]{
        let strArr = tsFileInfo.components(separatedBy: "\n")
        var tsFileArr = [String]()
        for line in strArr {
            if line.hasSuffix(".ts") {
                tsFileArr.append(line)
            }
        }
        
        return tsFileArr
    }
    
    func urlPathEncode(urlPath: String?) -> String? {
        guard urlPath != nil else {return nil}
        
        return urlPath?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    // MARK: - Table data source & delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TVideoCellID, for: indexPath) as! TVideoCell
        let vData = videoAssetArr[indexPath.row]
        cell.applyData(videoData: vData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoAssetArr.count
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! UITableViewCell
        let idPath = tableView.indexPath(for: cell)
        
        let videoInfo = videoAssetArr[idPath!.row]
        let videoDetailVC = segue.destination as! TVideoDetailViewController
        videoDetailVC.videoInfo = videoInfo
    }
}
