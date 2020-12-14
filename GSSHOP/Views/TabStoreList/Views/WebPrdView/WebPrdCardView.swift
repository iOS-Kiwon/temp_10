//
//  WebPrdCardView.swift
//  GSSHOP
//
//  Created by Home on 06/03/2020.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class WebPrdCardView: UIView {
    
    
    /// 카드 아이콘 이미지뷰
    @IBOutlet weak var iconImgView: UIImageView!
    /// 카드뷰가 추가될 베이스뷰
    @IBOutlet weak var baseView: UIView!
    /// 링크 화살표 이미지뷰
    @IBOutlet weak var linkImgView: UIImageView!
    
    private var cardData: Components?

    private var cardViewList = [WebPrdCardSubView]()
    
    private weak var aTarget: ResultWebViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: Components, target: ResultWebViewController? = nil) {
        self.cardData = data
        self.aTarget = target
        
        // 링크 여부에 따른 화살표 노출 여부
        if data.addInfoUrl.isEmpty == false {
            self.linkImgView.isHidden = false
        } else {
            self.linkImgView.isHidden = true
        }
        
        if data.cardImgUrl.isEmpty == false {
            // 아이콘
            ImageDownManager.blockImageDownWithURL(data.cardImgUrl as NSString) { (statusCode, image, imgURL, isInCache, error) in
                if error != nil || statusCode == 0 {
                    // 디폴트 이미지
                    self.setDefaultIconImage(data: data)
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
        } else {
            // 디폴트 이미지
            setDefaultIconImage(data: data)
        }
        
        
        

        for card in data.cardList {
            if let view = Bundle.main.loadNibNamed(WebPrdCardSubView.className, owner: self, options: nil)?.first as? WebPrdCardSubView {
                self.baseView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.setData(card)
                self.cardViewList.append(view)
            }
        }
        
        // 뷰 오토레이아웃 적용
        var lastAddedView: UIView?
        for view in self.cardViewList {
            view.layoutIfNeeded()
        
            var topConstraint: NSLayoutConstraint!
            if lastAddedView == nil {
                topConstraint = view.topAnchor.constraint(equalTo: self.baseView.topAnchor)
            } else {
                topConstraint = view.topAnchor.constraint(equalTo: lastAddedView!.bottomAnchor, constant: 4.0)
            }
            
            NSLayoutConstraint.activate([
                topConstraint,
                view.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor),
            ])
            
            lastAddedView = view
        }
        
        if lastAddedView != nil {
            lastAddedView!.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor).isActive = true
        }
        self.layoutIfNeeded()
    }
    
    
    /// 카드 또는 적립금의 디폴트 아이콘 노출함수
    func setDefaultIconImage(data: Components) {
        if data.cardList.count == 1,
            let firstData = data.cardList.first,
            firstData.templateType == WebTemplateType.savedMoneyInfo.name {
            self.iconImgView.image = UIImage(named: Const.Image.ic_card.name)
        } else {
            self.iconImgView.image = UIImage(named: Const.Image.ic_save_money.name)
        }
    }
    
    @IBAction func linkBtnAction(_ sender: UIButton) {        
        if let data = self.cardData, data.addInfoUrl.isEmpty == false {
            self.aTarget?.dealPrdUrlAction(data.addInfoUrl, withParam: "",loginCheck: false)
            self.aTarget?.sendAmplitudeAndMseq(withAction: "구매/배송_즉시할인")
        }
    }
}
