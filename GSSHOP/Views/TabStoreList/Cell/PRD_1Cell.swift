//
//  PRD_1Cell.swift
//  GSSHOP
//  https://zpl.io/aN559lN
//  일반 상품 영역 PRD_1
//  Created by admin on 28/10/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

import UIKit

class PRD_1Cell: BaseTableViewCell {
    
    //이미지
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var productImgHeight: NSLayoutConstraint!
    
    //방송시간 및 vod 벳지
    @IBOutlet weak var brdTimeView: UIView!
    @IBOutlet weak var brdTimeValue: UILabel!
    
    @IBOutlet weak var salePrice: UILabel!
    @IBOutlet weak var discountRate: UILabel!
    @IBOutlet weak var basePrice: UILabel!
    
    //상품명
    @IBOutlet weak var productName: UILabel!
    
    // 혜택
    @IBOutlet weak var benefitInfo: BenefitLabel!
    
    //리뷰
    @IBOutlet weak var reviewPoint: UILabel!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var reviewPointTailing: NSLayoutConstraint!
    
    @IBOutlet weak var viewBottomSpace: NSLayoutConstraint!
    
    //550 대응용
    @IBOutlet weak var prdImgLeading: NSLayoutConstraint! // 16 : 50
    @IBOutlet weak var prdImgTailing: NSLayoutConstraint! // 16 : 50
    
    @IBOutlet weak var brdTimeTailing: NSLayoutConstraint! // -8 : 0
    
    
    @IBOutlet weak var soldOut: UIView!
    // nami0342 : imageURL
    var imageURL : String?
    
    @objc var mTarget: AnyObject?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.brdTimeView.layer.cornerRadius = self.brdTimeView.frame.height/2
        self.productImgView.layer.borderColor = UIColor.getColor("000000", alpha: 0.06 ).cgColor
        //색만 지정 라인은 아래 지정됨
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.initUI()
    }
    
    func initUI() {
        self.productImgView.image = UIImage(named: Const.Image.img_noimage_375_188.name)
        
        self.brdTimeView.isHidden = true
        self.brdTimeValue.text = ""
        self.productName.text = ""
        self.productName.attributedText = NSAttributedString.init(string: "")
        self.salePrice.text = ""
        self.salePrice.attributedText = NSAttributedString.init(string: "")
        self.basePrice.attributedText = NSAttributedString.init(string: "")
        self.discountRate.attributedText = NSAttributedString.init(string: "")
        self.reviewCount.text = ""
        self.reviewPoint.text = ""
        self.benefitInfo.text = ""
        self.benefitInfo.attributedText = NSAttributedString.init()
        self.imageURL = ""
        self.soldOut.isHidden = true
    }
    
    @objc func setDivider(_ height:CGFloat) {
        self.viewBottomSpace.constant = height;
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func setCellInfoNDrawData(_ rowinfoDic: Dictionary<String, Any>, mPath:NSIndexPath) {
        guard let product = Module(JSON: rowinfoDic) else { return }
        setCellInfoDrawData(product: product, iPath:IndexPath(row: mPath.row, section: mPath.section) )
        self.imageURL = product.imageUrl
    }
    
    func setCellInfoDrawData(product: Module, iPath:IndexPath) {
        
        //640/550처리
        self.productImgHeight.constant = CGFloat(product.viewType.contains("640") ? Int(getAppFullWidth()-32)/2 : Int(getAppFullWidth() - 100))
        self.productImgHeight.isActive = true
        
        self.productImgView.image = product.viewType == "PRD_1_640" ? UIImage(named: Const.Image.img_noimage_375_188.name) : UIImage(named: Const.Image.img_noimage_375.name)
        //550일때와 640일때 간격이 다름.
        self.prdImgLeading.constant = product.viewType == "PRD_1_640" ? 16 : 50
        self.prdImgTailing.constant = product.viewType == "PRD_1_640" ? 16 : 50
        self.brdTimeTailing.constant = product.viewType == "PRD_1_640" ? -8 : 50-16
        //550은 이미지라인 없음
        self.productImgView.layer.borderWidth = product.viewType == "PRD_1_640" ? 1.0 : 0.0
        
        //19금 처리
        if product.adultCertYn == "Y" {
            if Common_Util.isthisAdultCerted() == false {
                self.productImgView.image = product.viewType == "PRD_1_640" ? UIImage(named: Const.Image.img_adult_375_188.name) : UIImage(named: Const.Image.img_adult_375.name)
            }
        }
        //정상 이미지 노출
        else {
            if product.imageUrl.isEmpty == false {
                ImageDownManager.blockImageDownWithURL(product.imageUrl as NSString) { (httpStatusCode, fetchedImage, strInputURL, isInCache, error) in
                    if error == nil, self.imageURL == strInputURL, let fImg = fetchedImage {
                        DispatchQueue.main.async {
                            
                            if isInCache == true {
                                self.productImgView.image = fImg
                            }
                            else {
                                self.productImgView.alpha = 0
                                self.productImgView.image = fImg
                                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                                    self.productImgView.alpha = 1
                                }, completion: { (finished) in
                                    self.layoutIfNeeded()
                                })
                            }
                        }//dispatch
                    }//if
                    else {
                        self.layoutIfNeeded()
                    }
                }
            } // if product.imageUrl
            else {
                self.productImgView.image = UIImage.init(named: "noimg_320.png")
                self.productImgHeight.constant = 160
                self.productImgHeight.isActive = true
                self.layoutIfNeeded()
            }
        }
        
        self.productName.setProductName(data: product)
        
        if product.broadTimeText.isEmpty == false {
            self.brdTimeValue.text = product.broadTimeText
            self.brdTimeView.isHidden = false
        }
        else {
            self.brdTimeView.isHidden = true
        }

        //판매가 노출
        self.salePrice.setSalePrice(data: product)
        
        // 할인율+베이스가 노출
        if product.discountRate > 0 {
            self.discountRate.setDiscountRate(withBaseLabel: self.basePrice, data: product, fontSize: 14.0)
        }
        else {
            self.discountRate.attributedText = NSAttributedString.init()
            self.basePrice.attributedText = NSAttributedString.init()
        }
        
        //상품평 개수 //아이폰5,4,SE일경우 갯수 노출 안함.
        if product.addTextRight.isEmpty == false, !isiPhone5(), !isiPhone4() {
            self.reviewCount.setReviewCount(data: product)
            self.reviewPointTailing.constant = -3.0
            
        }
        else {
            self.reviewCount.text = ""
            self.reviewPointTailing.constant = 0.0
        }
        
        
        //점수
        self.reviewPoint.setReviewAverage(data: product)
        
        //혜택
        if (product.allBenefit.count+((product.source?.text ?? "").isEmpty ? 0:1) ) > 0 {
            self.benefitInfo.attributedText = Common_Util.attributedBenefitString(product.toJSON(), widthLimit: getAppFullWidth() - 32, lineLimit: 1, fontSize: 14.0)
        }
        else {
            self.benefitInfo.attributedText = NSAttributedString.init()
        }
        
        //일시품절
        self.soldOut.isHidden = ("SOLD_OUT" == product.imageLayerFlag.uppercased()) ? false : true
        self.accessibilityLabel = "\(self.productName.text ?? "") \(self.salePrice.text ?? "")"
        self.layoutIfNeeded()
    }    
    
}
