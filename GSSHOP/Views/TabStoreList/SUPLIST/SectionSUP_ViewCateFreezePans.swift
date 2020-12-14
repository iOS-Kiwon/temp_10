//
//  SectionSUP_ViewCateFreezePans.swift
//  GSSHOP
//
//  Created by neocyon MacBook on 2020/09/17.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

class SectionSUP_ViewCateFreezePans: UIView {

    var row_arr: Array<Module> = Array()                                                   //carousel 로 표현할 전체뷰 데이터
    @objc weak var aTarget: AnyObject?                                                        //클릭시 이벤트를 보낼 타겟
    @objc var idxSelected:Int = -1                                                     //전체 갯수
    
    @IBOutlet weak var titleView: UIView!
    //공통 타이틀 베너 적용
    private var mBanner = BAN_TXT_IMG_LNK(frame: CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth()-65, height: 56.0))
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.frame = CGRect.init(x: 0.0, y: 0.0, width: getAppFullWidth(), height: 46.0)
        self.autoresizesSubviews = false
    }

    
    @objc func setCellInfoNDrawData(_ arrInfo: NSArray , andIndex : NSInteger ) {
        
        var posX: CGFloat = 10.0

        if (andIndex == self.idxSelected) {
            return;
        }else{
            for viewRemove in self.subviews {
                if (viewRemove.tag != 1000) {
                    viewRemove.removeFromSuperview()
                }
            }
        }

        for (i,dic) in arrInfo.enumerated() {
            if let dicRow = dic as? Dictionary<String,Any> {
                let productName = dicRow["productName"] as! String
                var lblFont = UIFont.systemFont(ofSize: 16.0)
                if (i == andIndex) {
                    lblFont = UIFont.boldSystemFont(ofSize: 16.0)
                }
                
                let sizeLbl = lblFont.sizeOfString(string: productName , constrainedToSize: CGSize.init(width: getAppFullWidth(), height: 46.0))
                
                let viewCate = UIView.init(frame: CGRect.init(x: posX, y: 7.5, width: 15.0 + sizeLbl.width + 15.0, height: 30.0))
                viewCate.clipsToBounds = true
                
                let lblCate = UILabel.init(frame: CGRect.init(x: 0.0, y: 0.0, width: viewCate.frame.size.width, height: viewCate.frame.size.height))
                lblCate.textAlignment = .center
                lblCate.font = lblFont
                lblCate.text = productName
                viewCate.addSubview(lblCate)
                
                let btnCate = UIButton.init(type: UIButton.ButtonType.custom)
                btnCate.accessibilityLabel = productName
                btnCate.frame = CGRect.init(x: 0.0, y: 0.0, width: viewCate.frame.size.width, height: viewCate.frame.size.height)
                //btnCate.addTarget(self, action: #selector(onBtnCate(_:)), for: .touchUpInside)
                btnCate.addTarget(self, action: #selector(self.onBtnCate(_:)), for: .touchUpInside)
                btnCate.tag = i
                viewCate.addSubview(btnCate)
                
                if (i == andIndex) {
                    lblCate.textColor = UIColor.white
                    lblCate.backgroundColor = UIColor.getColor("74bd3b")
                    viewCate.layer.cornerRadius = 15.0;
                    viewCate.layer.shouldRasterize = true;
                    viewCate.layer.rasterizationScale = UIScreen.main.scale;
                }else{
                    lblCate.textColor = UIColor.getColor("666666")
                    lblCate.backgroundColor = UIColor.clear
                }

                self.addSubview(viewCate)

                posX = posX + viewCate.frame.size.width;
            }
        }
        
        self.idxSelected = andIndex

    }
    
    @objc func onBtnCate(_ sender: UIButton){
        if let vc = self.aTarget as? SUPListTableViewController {
            vc.onBtnCateFreezePans(sender.tag)
        }
    }

    deinit {
        print("!!SectionSUP_ViewCateFreezePans deinit!!!")
    }
    
    

}
