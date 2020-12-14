//
//  SCH_BAN_MORETypeCell.swift
//  GSSHOP
//
//  Created by admin on 2020/06/30.
//  Copyright © 2020 GS홈쇼핑. All rights reserved.
//

import UIKit

@objc class SCH_BAN_MORETypeCell: UITableViewCell {
    
    @objc var bTarget:SListTBViewController?
    @objc var idxPath:IndexPath?
    
    @IBOutlet var lblMore:UILabel!
    @IBOutlet var imgArrowMore:UIImageView!
    @IBOutlet var viewCenter:UIView!
    @IBOutlet var viewDefault:UIView!
    @IBOutlet var btnMore:UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblMore.text = ""
        self.imgArrowMore.isHighlighted = false
    }

    @IBAction func onBtnBanner(_ sender: Any) {
        if self.bTarget != nil {
            let isShowMore = !self.imgArrowMore.isHighlighted
            self.bTarget?.touchSubProductStatus(isShowMore, andIndexPath: self.idxPath)
            //효율코드
            if isShowMore {
                if self.bTarget?.isLiveBrd() ?? false {
                    applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:"?mseq=A00323-C_SCH-SOPEN"))
                }
                else {
                    applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:"?mseq=A00323-C_SCH_D-SOPEN"))
                }
            }
            else {
                if self.bTarget?.isLiveBrd() ?? false {
                    applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:"?mseq=A00323-C_SCH-SCLOSE"))
                }
                else {
                    applicationDelegate.wiseLogRestRequest(wiselogcommonurl(pagestr:"?mseq=A00323-C_SCH_D-SCLOSE"))
                }
            }
            
        }
    }
    
    
    @objc func changeStatusWithStr(_ strText:NSString, andNumber strNum:NSString, andStatus isMore:Bool) {
        let strtext = strText as String
        let strnum = strNum as String
        self.lblMore.text = strtext + " ("+strnum+"개)"
        self.imgArrowMore.isHighlighted = !isMore
        if isMore {
            self.btnMore.accessibilityLabel = "관련성품 " + strnum + "개 더보기"
            self.lblMore.text = strtext + " " + strnum
        }
        else {
            self.btnMore.accessibilityLabel = "관련상품 닫기"
            self.lblMore.text = strnum
        }
        self.viewCenter.layoutIfNeeded()
        self.viewDefault.layoutIfNeeded()
    }
}
