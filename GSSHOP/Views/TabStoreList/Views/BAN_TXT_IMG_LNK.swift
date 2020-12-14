//
//  BAN_TXT_IMG_LNK.swift
//  GSSHOP
//
//
/*

 */
//  Created by admin on 04/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class BAN_TXT_IMG_LNK: UIView {
    
    private let titleView = UILabel()
    private let titleImgView = UIImageView()
    private let descriptView = UILabel()
    private let moreTextView = UILabel()
    private let moreArrowView = UIImageView()
    private let underLine = UIView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func prepareForReuse() {
        self.titleView.text = ""
        self.titleImgView.image = nil
        self.descriptView.text = ""
        //self.moreTextView.text = ""
        self.moreArrowView.image = nil
        
        self.removeAllConstraints()
        self.titleView.removeFromSuperview()
        self.titleImgView.removeFromSuperview()
        self.descriptView.removeFromSuperview()
        self.moreTextView.removeFromSuperview()
        self.moreArrowView.removeFromSuperview()
        self.underLine.removeFromSuperview()
        
        self.titleView.updateConstraints()
        self.titleImgView.updateConstraints()
        self.descriptView.updateConstraints()
        self.moreTextView.updateConstraints()
        self.moreArrowView.updateConstraints()
        self.underLine.updateConstraints()
    }
    
    //fontSize:19
    func makeGBAview(imageUrl:String = "", islink:Bool = false, title:String = "", subTittle:String = "", fontColor:String = "") {
        self.makeGBXview(imageUrl: imageUrl, islink: islink, title: title, subTittle: subTittle, fontColor: fontColor)
    }
    
    //fontSize:17
    func makeGBBview(imageUrl:String = "", islink:Bool = false, title:String = "", subTittle:String = "", fontColor:String = "") {
        self.makeGBXview(imageUrl: imageUrl, islink: islink, title: title, subTittle: subTittle, fontColor: fontColor, fontSize: 18.0)
    }
    
    // 텍스트 베너 (타이틀용) 공통 생성 모듈
    /*
     타이틀 영역 높이 (48 -> 56)
     위 마진 8 제거됨
     높이의 센터 정렬
     텍스트간 간격(8->10)
     더보기 화살표 변경
     타이틀 폰트 사이즈 변경(19->17) 111111
     서브 타이틀 속성 변경 (14)  a3111111
     */
    private func makeGBXview(imageUrl:String = "", islink:Bool = false, title:String = "", subTittle:String = "", fontColor:String = "", fontSize:CGFloat = 18.0) {
        //mainView[-16.0-titleView-10.0-barView-10.0-descriptView - <= 10 -moreTextView-moreArrowView-5-]
        //레이아웃 설정
        let margins = self//.layoutGuides
        
        self.accessibilityLabel = title
        
        // 1 step image or Title
        if !imageUrl.isEmpty { //이미지가 있으면 이미지 노출
            
            self.titleImgView.backgroundColor = .clear
            self.titleImgView.contentMode = .scaleToFill
            self.titleImgView.accessibilityLabel = title
            self.titleImgView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.titleImgView)
            
            self.titleImgView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16.0).isActive = true
            self.titleImgView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive = true
            
            ImageDownManager.blockImageDownWithURL(imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                if error == nil, imageUrl == strInputURL, let fImg = fetchedImage {
                    DispatchQueue.main.async {
                        if isInCache == true {
                            self.titleImgView.image = fImg
                            var hVal = fImg.size.height/2
                            if hVal >= 56 {
                                hVal = 56.0
                            }
                            
                            self.titleImgView.heightAnchor.constraint(equalToConstant: hVal).isActive = true
                            self.titleImgView.widthAnchor.constraint(equalToConstant: fImg.size.width/2).isActive = true
                            //NSLog("titleImgView: %f", fImg.size.width/2)
                            //NSLog("titleImgView: %f", self.titleImgView.frame.width)
                        }
                        else {
                            self.titleImgView.alpha = 0
                            self.titleImgView.image = fImg
                            var hVal = fImg.size.height/2
                            if hVal >= 56 {
                                hVal = 56
                            }
                            self.titleImgView.heightAnchor.constraint(equalToConstant: hVal).isActive = true
                            self.titleImgView.widthAnchor.constraint(equalToConstant: fImg.size.width/2).isActive = true
                            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                self.titleImgView.alpha = 1
                            }, completion: { (finished) in
                                
                            })
                        }
                        self.titleImgView.updateConstraints()
                        self.moreTextView.updateConstraints()
                        self.moreArrowView.updateConstraints()
                        self.descriptView.updateConstraints()
                    }//dispatch
                }//if
                else {
                    self.titleImgView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0.0).isActive = true
                    self.titleImgView.widthAnchor.constraint(equalToConstant: 0).isActive = true
                    
                    self.titleImgView.updateConstraints()
                    self.moreTextView.updateConstraints()
                    self.moreArrowView.updateConstraints()
                    self.descriptView.updateConstraints()
                }
            }
        }
        else {
            if !title.isEmpty {
                self.titleView.backgroundColor = .clear
                self.titleView.textColor = UIColor.getColor(fontColor, defaultColor: UIColor.getColor("111111") )
                self.titleView.text = title
                self.titleView.accessibilityLabel = title
                self.titleView.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.heavy)
                //UIFont.init(name: "NanumSquareEB", size: 18)
                self.titleView.translatesAutoresizingMaskIntoConstraints = false
                self.titleView.numberOfLines = 1
                self.titleView.lineBreakMode = .byClipping
                self.addSubview(self.titleView)
                self.titleView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16.0).isActive = true
                self.titleView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive = true
            }
        }
        
        
        // 2 step link 더보기
        if islink {
            self.moreArrowView.backgroundColor = .clear
            self.moreArrowView.image = UIImage.init(named: "title_arrowRight")
            self.moreArrowView.highlightedImage = UIImage.init(named: "title_arrowRight_press")
            self.moreArrowView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.moreArrowView)
            
            self.moreTextView.backgroundColor = .clear
            self.moreTextView.textColor = UIColor.getColor(fontColor, defaultColor: UIColor.getColor("a3111111") )
            self.moreTextView.text = "더보기" //to-do
            self.moreTextView.font = UIFont.systemFont(ofSize: 14.0)
            self.moreTextView.translatesAutoresizingMaskIntoConstraints = false
            self.moreTextView.highlightedTextColor = UIColor.getColor("111111")
            self.addSubview(self.moreTextView)
            
            self.moreArrowView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -5.0).isActive = true
            self.moreArrowView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive = true
            self.moreArrowView.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
            self.moreArrowView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
            
            self.moreTextView.trailingAnchor.constraint(equalTo: self.moreArrowView.leadingAnchor, constant: 7.0).isActive = true
            self.moreTextView.widthAnchor.constraint(equalToConstant: 37.0).isActive = true
            self.moreTextView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0).isActive = true
        }
        
        
        // 3 step discription //
        if !subTittle.isEmpty {
            self.descriptView.backgroundColor = .clear
            self.descriptView.textColor = UIColor.getColor(fontColor, defaultColor: UIColor.getColor("a3111111") )
            self.descriptView.text = subTittle
            self.descriptView.accessibilityLabel = subTittle
            self.descriptView.numberOfLines = 1
            self.descriptView.lineBreakMode = .byClipping
            self.descriptView.font = UIFont.systemFont(ofSize: 14.0)
            self.descriptView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.descriptView)
            
            if !imageUrl.isEmpty {
                self.descriptView.leadingAnchor.constraint(equalTo: self.titleImgView.trailingAnchor, constant:10.0).isActive = true
            }
            else if !title.isEmpty {
                self.descriptView.leadingAnchor.constraint(equalTo: self.titleView.trailingAnchor, constant:10.0).isActive = true
            }
            else {
                self.descriptView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 16.0).isActive = true
            }
            
            self.descriptView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 0.0).isActive = true
            
            if islink {
                self.descriptView.trailingAnchor.constraint(lessThanOrEqualTo: self.moreTextView.leadingAnchor, constant: -10.0).isActive = true
            }
            else {
                self.descriptView.trailingAnchor.constraint(lessThanOrEqualTo: margins.trailingAnchor, constant: -10.0).isActive = true
            }
        }
        else {
            if !imageUrl.isEmpty, islink {
                self.titleImgView.trailingAnchor.constraint(lessThanOrEqualTo: self.moreTextView.leadingAnchor, constant: -10.0).isActive = true
            }
            else if !title.isEmpty, islink {
                self.titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.moreTextView.leadingAnchor, constant: -10.0).isActive = true
            }
            else {//if imageUrl.isEmpty, title.isEmpty, islink {
                
            }
        }
        
        
        self.titleView.updateConstraints()
        self.titleImgView.updateConstraints()
        //self.descriptView.updateConstraints()
        self.moreTextView.updateConstraints()
        self.moreArrowView.updateConstraints()
        self.underLine.updateConstraints()        
    }
    
    func highlightedStatusSwitch(status:Bool) {
        self.moreTextView.isHighlighted = status
        self.moreArrowView.isHighlighted = status
    }
    //하단 라인 넣기
    func setUnderLine(use:Bool) {
        if use {
            self.underLine.frame = CGRect(x: 0, y: self.frame.height - 1.0, width:  getAppFullWidth(), height: 1.0)
            self.underLine.backgroundColor = UIColor.getColor("EEEEEE")
            self.addSubview(self.underLine)
        }
        else {
            self.underLine.removeFromSuperview()
        }
        
    }
}
