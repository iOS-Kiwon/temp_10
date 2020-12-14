//
//  Common_NFXC.swift
//  GSSHOP
//
//  Created by admin on 18/06/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit
/// NFXC에서 사용하는 공통 계산 및 로직
class Common_NFXC: NSObject {    
    /// 해텍 딱지 공통 영역
    static func makeBenefitStack(_ items:[ImageInfo], _ stackView:UIStackView) {
        //해텍 처리
        for iRB:ImageInfo in items {
            //처음이 아니면 점넣고 시작한다.
            if let firstRB:ImageInfo = items.first, !(iRB === firstRB) {
                let imgDot:UIImageView = UIImageView(image: UIImage.init(named: "dot_grey")) //dot이미지 추가
                imgDot.frame = CGRect(x: 0, y: 0, width: 3, height: 3)
                stackView.addArrangedSubview(imgDot)
            }
            
            let subView:UILabel = UILabel()
            subView.font = UIFont.systemFont(ofSize: 13)
            subView.textColor = UIColor.getColor("111111")
            subView.text = iRB.text
            stackView.addArrangedSubview(subView)
        }
    }
}
