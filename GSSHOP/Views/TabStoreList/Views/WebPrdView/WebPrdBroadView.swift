//
//  WebPrdBroadInfoView.swift
//  GSSHOP
//
//  Created by Kiwon on 2020/02/24.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdBroadView: UIView {
    
    /// 아이콘 이미지뷰
    @IBOutlet weak var logoImgView: UIImageView!
    ///아이콘과 텍스트 사이의 간격 기본 6
    @IBOutlet weak var logoImgSpaceText: NSLayoutConstraint!
    ///아이콘 가로
    @IBOutlet weak var logoImgViewWidth: NSLayoutConstraint!
    
    /// 방송정보 라벨
    @IBOutlet weak var broadTimeLbl: UILabel!
    /// 방송정보 라벨 오른쪽 여백
    @IBOutlet weak var broadTimeLblTrailing: NSLayoutConstraint!
    
    
    /// 방송알림 뷰
    @IBOutlet weak var notiView: UIView!
    /// 방송알림 이미지뷰
    @IBOutlet weak var notImgView: UIImageView!
    
    private var broadInfo: Components?
    
    private weak var aTarget: ResultWebViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.notiView.setCorner(radius: 2)
        self.notiView.setBorder(width: 1, color: "d9d9d9", alpha: 1.0)
    }
    
    func setData(_ data: Components, target: ResultWebViewController?) {
        self.broadInfo = data
        self.aTarget = target
        
        if data.broadChannelImgUrl.isEmpty == false {
            ImageDownManager.blockImageDownWithURL(data.broadChannelImgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                
                self.logoImgView.isHidden = false
                self.logoImgSpaceText.constant = 6.0
                
                if error != nil || statusCode == 0 {
                    if let image = UIImage(named: Const.Image.ic_brand.name) {
                        self.logoImgView.image = image
                            self.logoImgViewWidth.constant = image.size.width
                        self.logoImgView.layoutIfNeeded()
                    }
                    return
                }
                
                self.logoImgViewWidth.constant = self.makeRadioWidth(image?.size ?? CGSize(width: 0,height: 0), standardHeigth: self.logoImgView.frame.height)
                self.logoImgView.layoutIfNeeded()
                
                if isInCache == true {
                    self.logoImgView.image = image
                    
                } else {
                    self.logoImgView.alpha = 0
                    self.logoImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.logoImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
        else {
            self.logoImgView.isHidden = true
            self.logoImgViewWidth.constant = 0.0
            self.logoImgSpaceText.constant = 0.0
            self.logoImgView.layoutIfNeeded()
            
        }
        
        // 방송시간 설정
        let timeAttributedString = NSMutableAttributedString(string: "")
        let prdNameStyle = NSMutableParagraphStyle()
        prdNameStyle.alignment = .left
        prdNameStyle.lineBreakMode = .byWordWrapping
        prdNameStyle.minimumLineHeight = self.findMinimumLineHeight(data.broadText)
        timeAttributedString.addAttribute(
            .paragraphStyle, value: prdNameStyle,
            range: NSRange(location:0,
                           length: timeAttributedString.length))
        
        for data in data.broadText {
            let attrString = self.getAttributedString(withPrdTextInfo: data)
            timeAttributedString.append(attrString)
        }
        self.broadTimeLbl.attributedText = timeAttributedString
        
        // 방송알림 노출여부
        if "Y" == data.tvAlarmBtnFlg {
            self.notiView.isHidden = false
            self.broadTimeLblTrailing.constant = 7.0 + self.notiView.frame.width + 17.0 // 좌측여백 + 방송알림 Wisth + 우측여백
        } else {
            self.notiView.isHidden = true
            self.broadTimeLblTrailing.constant = 17.0
        }
        
        // 알림 설정여부
        if "Y" == data.applyBroadAlamYN {
            setBroadNotiBtnUI(isNoti: true)
        } else {
            setBroadNotiBtnUI(isNoti: false)
        }
    }
    
    /// 방송이 없는 경우
    private func setNoBroadUI() {
        self.logoImgView.isHidden = true
        self.logoImgViewWidth.constant = 0.0
        self.broadTimeLbl.text = ""
    }
    
    /// 방송알림 버튼 UI 설정
    func setBroadNotiBtnUI(isNoti noti: Bool) {
        
        if noti {
            // 알림 설정을 한 경우
            self.notImgView.image = UIImage(named: Const.Image.ic_notification_on.name)
            self.notiView.tag = 1
        } else {
            // 알림 설정을 안할 경우
            self.notImgView.image = UIImage(named: Const.Image.ic_notification_off.name)
            self.notiView.tag = 0
        }
        
    }

    @IBAction func notiBtnAction(_ sender: UIButton) {
        // 방송알림 버튼
        if let vc = self.aTarget,let data = self.broadInfo {
            vc.dealPrdUrlAction(data.runUrl, withParam: self.notiView.tag == 0 ? "on" : "off",loginCheck: true); // on/off값 전달
            vc.sendAmplitudeAndMseq(withAction: "TV_방송알림")
        }
    }
}
