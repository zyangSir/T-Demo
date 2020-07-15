//
//  TVideoCell.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import YYWebImage

let TVideoCellID = "TVideoCell"
class TVideoCell: UITableViewCell {
    
    @IBOutlet weak var dispView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func applyData(videoData: TVideoInfo!) {
        //这里要用异步缓存方式加载preview image
        dispView.yy_setImage(with: videoData.albumURL!, options: .progressiveBlur)
    
        //config video url
        
    }

}
