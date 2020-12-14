//
//  WebPrdDeliveryView.swift
//  GSSHOP
//
//  Created by Home on 06/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdDeliveryView: UIView {
    
    static let DEFAULT_TEXT_LABEL_HEIGHT: CGFloat = 20.0
    static let DEFAULT_BOTTOM_MARGIN: CGFloat = 16.0
    
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var iconImgView: UIImageView!

    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var linkImgView: UIImageView!
    
    @IBOutlet weak var linkBtn: UIButton!
    
    @IBOutlet weak var linkImgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryChangeView: UIView!
    
    @IBOutlet weak var deliveryChangeViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var deliveryChangeLbl: UILabel!

    /// 배송지정보 객체
    private var deliveryData: DeliveryInfo?
    /// 클릭 이벤트를 받을 타겟
    private weak var aTarget: ResultWebViewController?
    /// 배송지 주소변경 URL
    private var changeAddressUrlStr: String = ""
    
    /// 뷰 오토레이아웃 적용을 위한 맨 마지막 UIView 객체
    private var lastAddedView: UIView?
    /// 배송지뷰가 Add된 횟수
    private var deliveryViewAddCount : Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.deliveryChangeLbl.text = ""
        self.iconImgView.image = UIImage(named: Const.Image.ic_delivery_default.name)
    }
    
    func setData(_ data: DeliveryInfo, target: ResultWebViewController?) {
        self.deliveryData = data
        self.aTarget = target
        
        // 배송지 변경 테두리 UI 설정
        self.deliveryChangeView.setCorner(radius: 2)
        self.deliveryChangeView.setBorder(width: 1, color: "d9d9d9", alpha: 1.0)
        
        // 배송 아이콘
        if data.mainImgUrl.isEmpty == false {
            
            ImageDownManager.blockImageDownWithURL( data.mainImgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    self.iconImgView.image = UIImage(named: Const.Image.ic_delivery.name)
                    return
                }
                
                if isInCache == true {
                    self.iconImgView.image = image
                } else {
                    self.iconImgView.alpha = 0
                    self.iconImgView.image = image
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                        self.iconImgView.alpha = 1
                    }, completion: nil)
                }
            }
        }
        
        // 배송지 선택 / 변경 버튼 노출여부
        if data.changeAddress.count > 0 {
            
            if let firstItem = data.changeAddress.first, firstItem.linkUrl.isEmpty == false {
                self.changeAddressUrlStr = firstItem.linkUrl
            }
            
            let attributedString = NSMutableAttributedString(string: "")
            let minimumHeight: CGFloat = self.findMinimumLineHeight(data.changeAddress)
            
            for textInfo in data.changeAddress {
                let attrString = self.getAttributedString(withPrdTextInfo: textInfo)
                let style = NSMutableParagraphStyle()
                style.alignment = .left
                style.lineBreakMode = .byWordWrapping
                style.minimumLineHeight = minimumHeight
                attributedString.addAttribute(
                    .paragraphStyle, value: style,
                    range: NSRange(location:0,
                                   length: attributedString.length))
                
                attributedString.append(attrString)
            }
            let tempLbl = UILabel()
            tempLbl.numberOfLines = 1
            tempLbl.attributedText = attributedString
            tempLbl.sizeToFit()
            
            self.deliveryChangeViewWidth.constant = tempLbl.frame.width + (8 * 2) // 8 : 좌우 여백값
            self.deliveryChangeLbl.attributedText = attributedString
        } else {
            self.deliveryChangeLbl.text = nil
            self.deliveryChangeViewWidth.constant = 0.0
        }
        
        // 배송비 상세 링크 노출여부
        if data.addInfoUrl.isEmpty == false {
            self.linkImgView.image = UIImage(named: Const.Image.ic_arrow_right_24.name)
            self.linkImgViewWidth.constant = 24.0
        } else {
            self.linkImgView.image = nil
            self.linkImgViewWidth.constant = 0.0
        }

        for deliveryInfo in data.deliveryInfoList {

            var linkUrlStr = ""
            for textInfo in deliveryInfo.textList {
                if textInfo.linkUrl.isEmpty == false {
                    linkUrlStr = textInfo.linkUrl
                    break
                }
            }
            
            addDeliverySubView(dataList: deliveryInfo.textList, linkUrl: linkUrlStr, imageUrlStr: deliveryInfo.preImgUrl)
        }
        
        if let lastView = self.lastAddedView {
            lastView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor).isActive = true
        }
        
    }
    
    private func addDeliverySubView(dataList: [PrdTextInfo], linkUrl: String = "", imageUrlStr: String = "") {
        
        if let view = Bundle.main.loadNibNamed(WebPrdDeliverySubView.className, owner: self, options: nil)?.first as? WebPrdDeliverySubView {
            let add = view.setData(dataList, target: self.aTarget, linkUrl: linkUrl, imageUrlStr: imageUrlStr)
            if add {
                addTextView(view)
            }
        }
    }
    
    private func addTextView(_ view: UIView) {
        
        self.baseView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.deliveryViewAddCount += 1

        if let lastView = self.lastAddedView {
            
            if self.deliveryChangeViewWidth.constant != 0 {
                // 배송지 변경 버튼이 있는 경우
                
                if self.deliveryViewAddCount == 2 {
                    // 두번째 추가되는 뷰는 간격 8
                    view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 8.0).isActive = true
                } else if self.deliveryViewAddCount == 3 {
                    // 세번째 추가되는 뷰는 간격 4
                    view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 4.0).isActive = true
                } else {
                    // 네번째부터 추가되는 뷰는 간격 2
                    view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 2.0).isActive = true
                }
            } else {
                
                // 배송지 변경 버튼이 없는 경우 -> 간격 4
                view.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 4.0).isActive = true
            }
            
        } else {
            // 첫번째 추가되는 뷰 - BaseView와 간격 0
            view.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 0.0).isActive = true
        }
        view.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor).isActive = true
        
        //만약 옆에 배송지 버튼이 있다면 뷰의 폭 제한을 둔다. + 8 +
//        if self.deliveryChangeViewWidth.constant == 0 {
            let trailingAnchor = view.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor)
            trailingAnchor.priority = .defaultHigh
            trailingAnchor.isActive = true
//        } else {
//            view.trailingAnchor.constraint(equalTo: self.deliveryChangeLbl.leadingAnchor, constant: -8.0).isActive = true
//        }
        
        view.layoutIfNeeded()
        self.layoutIfNeeded()
        self.lastAddedView = view
    }

    @IBAction func deliveryChangeBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget {
            let strCheck = vc.reChangeNativeProductURL(onError: vc.urlString)
            let dataString = strCheck?.data(using: String.Encoding.utf8)
            print("dataStringdataString = \(String(describing: dataString?.base16EncodeSwift()))")
            vc.dealPrdUrlAction(self.changeAddressUrlStr, withParam: dataString?.base16EncodeSwift(),loginCheck: false)
            vc.sendAmplitudeAndMseq(withAction: deliveryChangeLbl.attributedText?.string)
        }
    }
    
    @IBAction func deliveryLinkBtnAction(_ sender: UIButton) {
        if let vc = self.aTarget, let data = self.deliveryData {
            vc.dealPrdUrlAction(data.addInfoUrl, withParam: nil, loginCheck: false)
            vc.sendAmplitudeAndMseq(withAction: "구매/배송_배송안내")
        }
    }

}
