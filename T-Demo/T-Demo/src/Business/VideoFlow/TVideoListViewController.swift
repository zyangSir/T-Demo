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
import SVProgressHUD

let PREVIEW_ALBUM_IMG_PATH = "https://s3-ap-southeast-2.amazonaws.com/maji-dev-buckets/images/DDC9C6DF-6986-4772-BA96-27F6EFB8CD94.png"

class TVideoListViewController: TBaseViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    
    var videoAssetArr = [TVideoInfo]()
    
    deinit {
        unRegisteNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //runAmplifyTest()
        self.title = "DevHub Demo"
        logoutBtn.layer.cornerRadius = logoutBtn.bounds.width/2
        
        registeNotification()
        //弹出登录
        TDUserManager.sharedInstance.tryAutoLogin { (success, err, msg) in
            if success == false {
                showLoginPage()
            }
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
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    // MARK: - Action
    @IBAction func logoutBtnClicked(_ sender: Any) {
        let accStr = "128"
        let msg = String("确定要登出当前账号：*\(accStr)* ?")
        let alertVC = UIAlertController(title: "登出", message: msg, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "确定", style: .default) { (action) in
            TDUserManager.sharedInstance.logout(done: nil)
        }
        
        let cancleAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        
        alertVC.addAction(sureAction)
        alertVC.addAction(cancleAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    // MARK: - Notification
    func registeNotification() {
        //监测登录成功通知
        let noti = NotificationCenter.default
        noti.addObserver(self, selector: #selector(onLoginSuccess), name: TD_LOGIN_SUCC_NOTIFICATION, object: nil)
        noti.addObserver(self, selector: #selector(onLogoutSuccess), name: TD_LOGOUT_SUCC_NOTIFICATION, object: nil)
    }
    
    func unRegisteNotification() {
        //移除通知
        let noti = NotificationCenter.default
        noti.removeObserver(self, name: TD_LOGIN_SUCC_NOTIFICATION, object: nil)
        noti.removeObserver(self, name: TD_LOGOUT_SUCC_NOTIFICATION, object: nil)
    }
    
    @objc func onLoginSuccess() {
        SVProgressHUD.show(withStatus: "精彩马上开始")
        DispatchQueue.global(qos: .background).async {
            self.loadVideoAssets()
        }
    }
    
    @objc func onLogoutSuccess() {
        DispatchQueue.main.async {
            self.showLoginPage()
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
        var priviousLine:String?
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
                        m3u8Res.srcType = "HLS"
                        parseOutExtInfo(m3u8Info: priviousLine!, videoInfo: m3u8Res)
                        videoAssetArr.append(m3u8Res)
                    }
                    
                } catch let err as NSError {
                    print(err)
                    break;
                }
                
            }
            priviousLine = line
        }
        
        //MP4 视频地址
        let mp4Path = "https://s3-ap-southeast-2.amazonaws.com/maji-dev-buckets/videos/8A2E394C-008F-48C4-9EBD-47D16BA54E5C.mp4"
        
        let mp4Res = TVideoInfo(albumPath: PREVIEW_ALBUM_IMG_PATH, streamPath: urlPathEncode(urlPath: mp4Path)!)
        mp4Res.resolution = CGSize(width: 1080, height: 1920)
        mp4Res.frameRate = 30
        mp4Res.srcType = "MP4"
        videoAssetArr.append(mp4Res)
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
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
    
    func parseOutExtInfo(m3u8Info: String, videoInfo: TVideoInfo){
        
        let infoArr = m3u8Info.components(separatedBy: ",")
        for info in infoArr {
            if info.hasPrefix("RESOLUTION") {
                let resolution = info.components(separatedBy: "=").last
                let w = (resolution?.components(separatedBy: "x").first ?? "0") as String
                let h = (resolution?.components(separatedBy: "x").last ?? "0") as String
                videoInfo.resolution = CGSize(width: CGFloat(Double(w)!), height: CGFloat(Double(h)!))
            }else if info.hasPrefix("FRAME-RATE") {
                let frameRate = (info.components(separatedBy: "=").last ?? "0") as String
                videoInfo.frameRate = CGFloat(Double(frameRate)!)
            }
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    func showLoginPage(){
        let loginVc = TDLoginStoryBoard().instantiateInitialViewController()!
        loginVc.modalPresentationStyle = .fullScreen
        self.present(loginVc, animated: true, completion: nil)
    }
}
