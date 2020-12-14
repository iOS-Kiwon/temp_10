//
//  SCH_BAN_IMG_W540TypeCell.swift
//  GSSHOP
//
//  Created by Kiwon on 25/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class SCH_BAN_IMG_W540TypeCell: UITableViewCell {
    
    @objc var aTarget: AnyObject?
    private var broadProduct: BroadProduct?
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var button: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.button.isAccessibilityElement = false
        self.button.accessibilityLabel = ""
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = UIImage(named: Const.Image.noimg_25.name)
        self.button.isAccessibilityElement = false
        self.button.accessibilityLabel = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>, indexPath: IndexPath) {
        guard let broadPrd = BroadProduct(JSON: rowinfoDic) else { return }
        self.broadProduct = broadPrd
        
        guard let liveBanner = broadPrd.liveBanner else { return }
        
        // 접근성 설정
        self.button.isAccessibilityElement = true
        if !liveBanner.text.isEmpty {
            self.button.accessibilityLabel = liveBanner.text
        } else {
            self.button.accessibilityLabel = Const.Text.image_banner.name
        }
        
//        liveBanner.imageUrl = "http://image.gsshop.com/image/50/64/50640527_L1.jpg"
        
        ImageDownManager.blockImageDownWithURL(liveBanner.imageUrl as NSString) { (httpStatusCode, fetchedImage, imgUrl, isInCache, error) in
            if error == nil, liveBanner.imageUrl == imgUrl, let image = fetchedImage {
                DispatchQueue.main.async {
                    // 동적 이미지 높이 계산 후 적용
                    if liveBanner.height.isEmpty {
                        //UI개편으로 인한 확장
                        //let dynamicHeight = image.size.height / image.size.width * (getAppFullWidth() - 102.0) + self.imgView.frame.origin.y
                        let dynamicHeight = image.size.height / image.size.width * getAppFullWidth() + self.imgView.frame.origin.y
                        if let height =  NumberFormatter().string(from: NSNumber(value: Float(dynamicHeight))),
                            let tableVC = self.aTarget as? SListTBViewController {
                            broadPrd.liveBanner?.height = height
                            tableVC.tableCellReload(forHeight: broadPrd.toJSON(), indexPath: indexPath)
                        }
                        return
                    }
                    if isInCache == true {
                        self.imgView.image = image
                    }
                    else {
                        self.imgView.alpha = 0
                        self.imgView.image = image
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                            self.imgView.alpha = 1
                        })
                    }
                }//dispatch
            }//if

        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let broadPrd = self.broadProduct else { return }
        
//        guard let method = self.aTarget?.touchEventTBCell else { return }
//        method(broadPrd.toJSON())
        guard let method = self.aTarget?.touchEventTBCell else { return }
        method(broadPrd.liveBanner?.toJSON())
    }
}
