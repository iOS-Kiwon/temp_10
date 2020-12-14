//
//  SectionSUPBannerModalCell.swift
//  GSSHOP
//
//  Created by Home on 2020/09/15.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionSUPBannerModalCell: UITableViewCell {
    
    @IBOutlet weak var imgBanner: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = {
            let view = UIView()
            view.backgroundColor = .white
            return view
        }()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgBanner.image = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(_ data: Module) {
        
        if data.imageUrl.isEmpty {
            return
        }
        
        // 이미지 다운로드
        ImageDownManager.blockImageDownWithURL(data.imageUrl as NSString) { (httpStatusCode, fetchedImage, imageUrl, isInCache, error) in
            if error == nil , let image = fetchedImage {
                DispatchQueue.main.async {
                    let size = CGSize(width: self.imgBanner.frame.size.width,
                                      height: self.imgBanner.frame.size.height)
                    if isInCache == true {
                        self.imgBanner.image = image.aspectFill(to: size)
                    }
                    else {
                        self.imgBanner.alpha = 0
                        self.imgBanner.image = image.aspectFill(to: size)
                        UIView.animate(withDuration: 0.2,
                                       delay: 0.0,
                                       options: .curveEaseInOut,
                                       animations: {
                                        self.imgBanner.alpha = 1
                        })
                    }
                }
            }
        }
        
        
        
        self.imgBanner.accessibilityTraits = .button
        self.imgBanner.accessibilityLabel = data.productName
    }

}
