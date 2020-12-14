//
//  SectionBP_OtypeCell.swift
//  GSSHOP
//
//  Created by Parksegun on 2016. 10. 17..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//  메인이미지 아래 상품이 꼽히는 셀입니다.

//let ApplicationDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
//let APPFULLWIDTH = UIScreen.mainScreen().bounds.size.width;
//let APPFULLHEIGHT = UIScreen.mainScreen().bounds.size.height;

@objc class SectionBP_OtypeCell:UITableViewCell{
    
        
    @IBOutlet var view_Default: UIView!;
    @IBOutlet var contentsView: UIView!;         // 상품 정보 뷰
    @IBOutlet var bannerImage: UIImageView!;     // 상단 베너 이미지
    @IBOutlet var noImage: UIImageView!;         // 노이미지
    @IBOutlet var productImage: UIImageView!;    // 상품 이미지
    @IBOutlet var LT: UIImageView!;              // 상품 이미지 Left Top 벳지
    @IBOutlet var productName: UILabel!;         // 상품평
    @IBOutlet var discountRate: UILabel!;        // 할인율
    @IBOutlet var discountRatePercent: UILabel!; // 할인율% 혹은 텍스트
    @IBOutlet var salePrice: UILabel!;           // 할인가
    @IBOutlet var salePriceWon: UILabel!;        // 할인가 원/원~
    @IBOutlet var basePrice: UILabel!;           // 기본가
    @IBOutlet var basePriceCancelLine: UIView!;  // 기본가 취소선
    @IBOutlet var valuetext: UILabel!;           // 금액 관련 정보 (원 렌탈료)
    @IBOutlet var valueinfo: UILabel!;           // 금액 관련 안내 (프로모션 네임)
    @IBOutlet var TF: UILabel!;                  // 상품명 앞에 백화점/매장 정보
    @IBOutlet var arrow: UIImageView!;           // 화살표

    @IBOutlet var underLine: UIView!;            // 상단 베너 아래 라인
    @IBOutlet var underLine2: UIView!;           // 상품 아래 라인


    var imageLoadingOperation: MochaNetworkOperation?;         // 상품 이미지 오퍼리에터
    var imageLoadingOperationBYbanner: MochaNetworkOperation?; // 상단 베너 이미지 오퍼레이터
    var imageLoadingOperationByLT: MochaNetworkOperation?;     // 상품 이미지 좌상단 벳지 이미지 오퍼레이터
    var imageURL: String?;                         // 상품 이미지 경로
    var imageURLBybanner: String?;                 // 상단 베너 이미지 경로
    var infoDic: NSDictionary?;                      // 셀 정보 구조체
   
    
    var targettb: AnyObject?;
    
    
    
    
    //MARK: override
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
        self.backgroundColor = UIColor.clearColor();
    }
    
    override func prepareForReuse() {
        super.prepareForReuse();
        
        self.bannerImage.hidden = true;
        self.productImage.hidden = true;
        self.LT.hidden = true;
        self.productName.text = "";
        self.productName.hidden = true;
        self.discountRate.text = "";
        self.discountRate.hidden = true;
        self.discountRatePercent.hidden = true;
        self.salePrice.text = "";
        self.salePrice.hidden = true;
        self.salePriceWon.text = "";
        self.salePriceWon.hidden = true;
        self.basePrice.text = "";
        self.basePrice.hidden = true;
        self.basePriceCancelLine.hidden = true;
        self.valueinfo.text = "";
        self.valueinfo.hidden = true;
        self.valuetext.text = "";
        self.valuetext.hidden = true;
        self.TF.text = "";
        self.TF.hidden = true;
        
        //하단 베너 지움.
        self.contentsView.hidden = true;
        //하단바위치 숨김처리
        self.underLine.hidden = true;
        self.underLine2.hidden = true;
        self.arrow.hidden = true;
        
        
        self.backgroundColor = UIColor.clearColor();
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated);
        
    }
    
    
    
    
    
    //MARK: func
    
    
    func setCellInfoNDrawData(rowinfoArr: NSDictionary)
    {
        self.backgroundColor = UIColor.clearColor();
        
        if let xArr:NSDictionary  = rowinfoArr
        {
            // 상단 이미지 베너 시작
            if let image:NSString = xArr.objectForKey("imageUrl") as? NSString
            {
                self.imageURLBybanner = image as String;
                if(image.length > 0)
                {
                    self.bannerImage.hidden = false;
                    
                    self.imageLoadingOperation = ApplicationDelegate.gsshop_img_core.imageAtURL(NSURL(string: self.imageURLBybanner!), sloadertype: MochaNetworkOperationLINone, onCompletion: { (fetchedImage, url, isInCache) in
                        
                        if (isInCache)
                        {
                            self.bannerImage.image = fetchedImage;
                        }
                        else
                        {
                            self.bannerImage.alpha = 0;
                            self.bannerImage.image = fetchedImage;
                            
                            
                            UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                                animations:
                                {
                                    self.bannerImage.alpha = 1;
                                },
                                completion:
                                { (finished) in
                                    //noting
                                }
                            );
                            
                        }
                    });

                   

                }
                else
                {
                     self.bannerImage.hidden = true;
                }
                
                
            }
            else
            {
                self.bannerImage.hidden = true;
            }// if let image
            
            
            
            
            if let subPro = xArr.objectForKey("subProductList")
            {
                    self.infoDic =  subPro.objectAtIndex(0) as? NSDictionary;
                
                    self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH, CGFloat(Mocha_Util.DPRateOriginVAL(160)) + 130);
                    self.bannerImage.frame = CGRectMake(0, 0, APPFULLWIDTH, CGFloat(Mocha_Util.DPRateOriginVAL(160)) );
                    self.noImage.frame = self.bannerImage.frame;
                    
                    self.contentsView.hidden = false;
                    //하단바위치 이동? 지움?
                    self.underLine.hidden = false;
                    self.underLine2.hidden = true;
                    self.arrow.hidden = false;
            }
            else
            {
                
                self.view_Default.frame = CGRectMake(0, 0, APPFULLWIDTH, CGFloat(Mocha_Util.DPRateOriginVAL(160)) );
                self.bannerImage.frame = CGRectMake(0, 0, APPFULLWIDTH, CGFloat(Mocha_Util.DPRateOriginVAL(160)) );
                self.noImage.frame = self.bannerImage.frame;
                
                //하단 베너 지움.
                self.contentsView.hidden = true;
                //하단바위치 이동? 지움?
                self.underLine.hidden = true;
                self.underLine2.hidden = false;
                self.underLine2.frame = CGRectMake(0, CGFloat(Mocha_Util.DPRateOriginVAL(160)-1), APPFULLWIDTH, 1);
                self.arrow.hidden = true;
                return;
                
            }// if let subPro

            
            
            ///////////////// 하위 상품 /////////////////
            
            ///////////////// 상품이미지 시작 /////////////////
            
            if let info:NSDictionary = self.infoDic
            {
                //19금 제한
                if (info.objectForKey("adultCertYn") as? String == "Y")
                {
                    if( Common_Util.isthisAdultCerted() == false)
                    {
                        self.productImage.image =  UIImage(named: "prevent19cellimg");
                        self.productImage.hidden = false;
                    }
                    else
                    {
                        if let image:NSString = info.objectForKey("imageUrl") as? NSString
                        {
                            self.productImage.hidden = false;

                            self.imageURL = image as String;
                            if(image.length > 0)
                            {
                                
                                self.imageLoadingOperation = ApplicationDelegate.gsshop_img_core.imageAtURL(NSURL(string: self.imageURL!), sloadertype: MochaNetworkOperationLINone, onCompletion: { (fetchedImage, url, isInCache) in
                                    
                                    if (isInCache)
                                    {
                                        self.productImage.image = fetchedImage;
                                    }
                                    else
                                    {
                                        self.productImage.alpha = 0;
                                        self.productImage.image = fetchedImage;
                                        
                                        
                                        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                                            animations:
                                            {
                                                self.productImage.alpha = 1;
                                            },
                                            completion:
                                            { (finished) in
                                                //noting
                                            }
                                        );
                                        
                                    }
                                });

                                
                            }
                        }
                        else
                        {
                            self.productImage.hidden = true;
                        }// if let image

                    } // isthisAdultCerted
                    
                }
                else //19금 아님.
                {
                    if let image:NSString = info.objectForKey("imageUrl") as? NSString
                    {
                        self.productImage.hidden = false;
                        
                        self.imageURL = image as String;
                        if(image.length > 0)
                        {
                            
                            self.imageLoadingOperation = ApplicationDelegate.gsshop_img_core.imageAtURL(NSURL(string: self.imageURL!), sloadertype: MochaNetworkOperationLINone, onCompletion: { (fetchedImage, url, isInCache) in
                                
                                if (isInCache)
                                {
                                    self.productImage.image = fetchedImage;
                                }
                                else
                                {
                                    self.productImage.alpha = 0;
                                    self.productImage.image = fetchedImage;
                                    
                                    
                                    UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut,
                                        animations:
                                        {
                                            self.productImage.alpha = 1;
                                        },
                                        completion:
                                        { (finished) in
                                            //noting
                                        }
                                    );
                                    
                                }
                            });
                            
                            
                        }
                    }
                    else
                    {
                        self.productImage.hidden = true;
                    }// if let image

                }// if adult
                ///////////////// 상품이미지 종료 /////////////////
                
                
                /////////// LT 벳지 카운트 정보 출력 시작 /////////
                
                if(info.objectForKey("dealProductType") as? String == "Deal")
                {
                    self.LT.hidden = false;
                }
                else
                {
                    self.LT.hidden = true;
                }
                /////////// LT 벳지 카운트 정보 출력 종료 /////////
                

                
                ////////// 상품명 노출 시작 (feat. TF)/////////
                if let badge:NSDictionary = info.objectForKey("infoBadge") as? NSDictionary, let tf:NSArray = badge.objectForKey("TF") as? NSArray
                {
                    
                    switch ( tf.count )
                    {
                    case 0:
                        self.TF.hidden = true;
                        self.TF.text = "";
                        break;
                        
                    case 1:
                        
                        self.TF.hidden = false;
                        
                        //FIXME: 여기는 nil에 대해 어떻게 동작하는지 확인이 필요하다.
                        self.TF.text =  (tf.objectAtIndex(0) as? NSDictionary)?.objectForKey("text") as? String;
                        if let type:String = (tf.objectAtIndex(0) as? NSDictionary)?.objectForKey("type") as? String
                        {
                            self.TF.textColor =  Mocha_Util.getColor(type);
                        }
                        
                        
                        self.TF.sizeToFit();
                        
                        break;
                        
                    default:
                        break;
                    }

                    
                }
                else    // nami0342 - NCA
                {
                    self.TF.hidden = true;
                    self.TF.text = "";
                }
                
                // 상품명 앞에 TF값이 있으면 넣어준다. 공간 확보용
                
                if let prdName:String = info.objectForKey("productName") as? String
                {
                    
                    if( self.TF.hidden )
                    {
                        self.productName.text = prdName
                    }
                    else
                    {
                        self.productName.text = self.TF.text! + " " + prdName;
                    }
                    
                    self.productName.text =  prdName + "\n";//줄바꿈?
                    
                    if(self.productName.text?.utf16.count > 0)
                    {
                        self.productName.hidden = false;
                        self.productName.sizeToFit();
                        
                        
                        // 위치 보정 시작
                        self.productName.frame = CGRectMake(10+110+15, 20, APPFULLWIDTH - 15 - self.productName.frame.origin.x, self.productName.frame.size.height);
                        self.TF.frame = CGRectMake(self.productName.frame.origin.x, self.productName.frame.origin.y, self.TF.frame.size.width + 1, self.TF.frame.size.height);
                    }
                    else
                    {
                        self.productName.hidden = true;
                    }
                
                }
                else
                {
                    self.productName.hidden = true;
                }
                // if let prdName
                ////////// 상품명 노출 종료 //////////

                
                var disCountVarInt:Int? = nil; //nil일수 있다.
                
                ///////// 할인율 노출 //////////
                // 할인율 / GS가 
                //FIXME: discountRate 값 0을(Int32로 인식) String으로 캐스팅 하지 못하는 문제가 있다. if let에서 failed 됨. 방법을 찾아야한다....
                //let discountVar = info.objectForKey("discountRate") as? NSString
                // 0 일때와 nil일때는 다르다. nil은 히든, 0일때는 GS가를 표시
                if let discountVar:Int = info.objectForKey("discountRate") as? Int, let discountTxt:String = info.objectForKey("discountRateText") as? String
                {
                    disCountVarInt = discountVar;
                    
                    if(discountTxt.utf16.count > 0)
                    {
                        if(discountTxt == "GS가")
                        {
                            self.discountRatePercent.text = discountTxt;
                            self.discountRate.hidden = true;
                            self.discountRatePercent.hidden = false;
                            // 사이즈 조정
                            self.discountRatePercent.sizeToFit();
                            self.discountRatePercent.frame = CGRectMake(self.productName.frame.origin.x, 71, self.discountRatePercent.frame.size.width, self.discountRatePercent.frame.size.height);
                        }
                        else
                        {
                            //그냥 값만 표시
                            self.discountRate.text = discountTxt
                            self.discountRate.hidden = false;
                            self.discountRatePercent.hidden = true;
                            
                            self.discountRate.sizeToFit();
                            //사이즈 조정
                            self.discountRate.frame = CGRectMake(self.productName.frame.origin.x, 64, self.discountRate.frame.size.width, self.discountRate.frame.size.height);
                        }
                    }
                    else if(discountVar >= 0) //0보다 크다면..
                    {
                        
                        if(discountVar < 5)
                        {
                            self.discountRatePercent.text = "GS가";
                            self.discountRate.hidden = true;
                            self.discountRatePercent.hidden = false;
                            // 사이즈 조정
                            self.discountRatePercent.sizeToFit();
                            self.discountRatePercent.frame = CGRectMake(self.productName.frame.origin.x, 71, self.discountRatePercent.frame.size.width, self.discountRatePercent.frame.size.height);
                        }
                        else
                        {
                            self.discountRate.text = String(discountVar);
                            self.discountRatePercent.text = "%";
                            //할인율 표시
                            self.discountRate.hidden = false;
                            self.discountRatePercent.hidden = false;
                            
                            self.discountRate.sizeToFit();
                            self.discountRatePercent.sizeToFit();
                            //사이즈 조정
                            self.discountRate.frame = CGRectMake(self.productName.frame.origin.x, 64, self.discountRate.frame.size.width, self.discountRate.frame.size.height);
                            self.discountRatePercent.frame = CGRectMake(self.discountRate.frame.origin.x + self.discountRate.frame.size.width , 71, self.discountRatePercent.frame.size.width, self.discountRatePercent.frame.size.height);
                        }// < 5
                        
                    }
                    else
                    {
                        //전체 뷰히든
                        self.discountRate.hidden = true;
                        self.discountRatePercent.hidden = true;
                    }
                    // if(disc
                }
                else
                {
                    //전체 뷰히든
                    self.discountRate.hidden = true;
                    self.discountRatePercent.hidden = true;
                }// if let discount
                ///////// 할인율 노출 종료//////////
                
                
                
                
                
                //////// 판매금액 노출 시작 ////////
                
                var isalePrice = 0;
                
                if let price:String = info.objectForKey("salePrice") as? String
                {
                    // 판매 가격
                    let removeCommadrstr: String = Mocha_Util.strReplace(",", replace: "", string: price);
                    
                    if( Common_Util.isThisValidWithZeroStr(removeCommadrstr) == true)
                    {
                        
                        isalePrice = Int(removeCommadrstr)!;
                        
                        self.salePrice.text = Common_Util.commaStringFromDecimal(Int32(isalePrice));
                        self.salePriceWon.text  =  info.objectForKey("exposePriceText") as? String;
                        
                        
                        self.salePrice.hidden = false;
                        self.salePriceWon.hidden = false;
                        
                        // 위치 보정
                        self.salePrice.sizeToFit();
                        self.salePriceWon.sizeToFit();
                        
                        //마진, 이미지, GS가 포함 여백
                        var margin = 0;
                        if(self.discountRate.hidden == true && self.discountRatePercent.hidden == false) //GS가
                        {
                            margin = 10+110 + 15 + Int(self.discountRatePercent.frame.size.width) + 4;
                        }
                        else if(self.discountRate.hidden == false && self.discountRatePercent.hidden == false) //할인율
                        {
                            margin = 10+110 + 15 + Int(self.discountRate.frame.size.width) + Int(self.discountRatePercent.frame.size.width) + 8;
                        }
                        else // 없음.
                        {
                            margin = Int(self.productName.frame.origin.x);
                        }
                        self.salePrice.frame = CGRectMake(CGFloat(margin), 71, self.salePrice.frame.size.width, self.salePrice.frame.size.height);
                        self.salePriceWon.frame = CGRectMake(self.salePrice.frame.origin.x + self.salePrice.frame.size.width, self.salePrice.frame.origin.y, self.salePriceWon.frame.size.width, self.salePriceWon.frame.size.height);
                        
                        
                    }
                    else
                    {
                        //숫자아님
                        self.salePrice.hidden = true;
                        self.salePriceWon.hidden = true;
                        
                    }
                    
                    
                }
                else
                {
                    
                    self.salePrice.hidden = true;
                    self.salePriceWon.hidden = true;
                }// if let price
                
                //////// 판매금액 노출 종료 ////////
                

                
                //////// 원래금액 노출 시작 ////////
                
                
                if let base:String = info.objectForKey("basePrice") as? String
                {
                    let removeCommaorgstr:String = Mocha_Util.strReplace(",", replace: "", string: base);
                    let ibasePrice = Int(removeCommaorgstr);
                    
                    if (ibasePrice > 0 && ibasePrice > isalePrice)
                    {
                        // 모든 상품중 discountRate 가 5 미만 basePrice 를 노출하지 않음
                        if(disCountVarInt != nil && disCountVarInt < 5)
                        {
                            self.basePrice.text = "";
                            self.basePriceCancelLine.hidden = true;
                            self.basePrice.hidden = true;
                        }
                        else
                        {
                            //FIXME: 예외가 발생할수 있다.. 고민해보자
                            let strBase = Common_Util.commaStringFromDecimal(Int32(ibasePrice!));
                            let strText = info.objectForKey("exposePriceText") as? String;
                            
                            self.basePrice.text = strBase+strText!;
                            self.basePrice.hidden = false;
                            self.basePriceCancelLine.hidden = false;
                            
                            let fontWithAttributes = [NSFontAttributeName: UIFont.systemFontOfSize(11)];
                            let textSize:CGSize =  strBase.sizeWithAttributes(fontWithAttributes);
                            
                            //위치 보정
                            self.basePrice.sizeToFit();
                            self.basePrice.frame = CGRectMake(self.salePrice.frame.origin.x, self.salePrice.frame.origin.y - self.basePrice.frame.size.height + 2, self.basePrice.frame.size.width, self.basePrice.frame.size.height);
                            self.basePriceCancelLine.frame = CGRectMake(self.basePrice.frame.origin.x, 59 + self.basePrice.frame.size.height/2, textSize.width, 1);
                            
                        }
                        
                    }
                    else
                    {
                        self.basePrice.text = "";
                        self.basePrice.hidden = true;
                        self.basePriceCancelLine.hidden = true;
                        
                    }

                }
                else
                {
                    self.basePrice.text = "";
                    self.basePriceCancelLine.hidden = true;
                    self.basePrice.hidden = true;
                    
                }//if let base
                
                
                //////// 원래금액 노출 종료 ////////
                
                
                //////// valueText 노출 시작 ///////
                if let val:String = info.objectForKey("valueText") as? String
                {
                    if(val.utf8.count > 0)
                    {
                        self.valuetext.hidden = false;
                        self.valuetext.text = val.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet());
                        self.valuetext.sizeToFit();
                        self.valuetext.frame = CGRectMake(self.salePrice.frame.origin.x, self.salePrice.frame.origin.y - self.valuetext.frame.size.height + 2, self.valuetext.frame.size.width, self.valuetext.frame.size.height);
                    }
                    else
                    {
                        self.valuetext.text = "";
                        self.valuetext.hidden = true;
                    }
                    
                }
                else
                {
                    self.valuetext.text = "";
                    self.valuetext.hidden = true;
                    
                }
                //////// valueText 노출 종료 ///////
                
                
            }//if let info
            else
            {
                
            }
    
        }// if let xArr
        else
        {
            
        }
        
    }//func
    
    
    
    
    //MARK: IBAction
    
    @IBAction func clickProduct(sender: AnyObject)
    {
        if let atarget = self.targettb, let xDic = self.infoDic
        {
            atarget.dctypetouchEventTBCell(xDic as [NSObject : AnyObject], andCnum: sender.tag, withCallType: "BP_O");
        }
    
    
    }
    
}






















