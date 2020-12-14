//
//  GR_BRD_GBATypeSubImgCell.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/08/20.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class GR_BRD_GBATypeSubImgCell: UICollectionViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isAccessibilityElement = true
        self.accessibilityLabel = "이미지 배너"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
    }
    
    func setData(_ module: Module) {
        
        let imageUrl = module.imageUrl
        if imageUrl.hasPrefix("http") {
            ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, imageUrl == strInputURL, let fImg = fetchedImage {
                    DispatchQueue.main.async {

                        self.imgView.image = fImg
                        
                    }//dispatch
                }
            }
        }
        
        self.layoutIfNeeded()
    }
}
