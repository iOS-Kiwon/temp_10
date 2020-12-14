//
//  BaseCollectionViewCell.swift
//  GSSHOP
//
//  Created by Kiwon on 01/11/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    /// Cell 전체를 Scale 비율로 축소
    func didHighlightCell(_ scale: CGFloat = 0.96) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: 0.1) {
            self.contentView.transform = transform
        }
    }
    
    /// Cell 전체를 Scale 비율로 확대
    func didUnhighlightCell(_ scale: CGFloat = 1.0) {
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        UIView.animate(withDuration: 0.1) {
            self.contentView.transform = transform
        }
    }
}
