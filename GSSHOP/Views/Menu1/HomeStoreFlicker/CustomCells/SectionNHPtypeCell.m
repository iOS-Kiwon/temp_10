//
//  SectionNHPtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 5. 26..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionNHPtypeCell.h"
#import "Common_Util.h"
#import "AppDelegate.h"
#import "NTCListTBViewController.h"

@implementation SectionNHPtypeCell

@synthesize view_Default,productImage,productName,discountRate,discountRatePercent,salePrice,salePriceWon,saleCount,saleCountMsg,time,hashTagView,timeView,cellClick;

@synthesize target;

- (void)awakeFromNib {

    [super awakeFromNib];
    
        self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) prepareForReuse{
   
    [super prepareForReuse];
    
    self.productImage.image = nil;
    self.productImage.hidden = YES;
    self.productName.hidden = YES;
    self.productName.text = @"";
    self.discountRate.hidden = YES;
    self.discountRate.text = @"";
    self.discountRatePercent.hidden = YES;
    self.discountRatePercent.text = @"";
    self.salePrice.hidden = YES;
    self.salePrice.text = @"";
    self.salePriceWon.hidden = YES;
    self.salePriceWon.text = @"";
    self.saleCount.hidden = YES;
    self.saleCount.text = @"";
    self.saleCountMsg.hidden = YES;
    self.time.hidden = YES;
    self.time.text = @"";
    self.timeView.hidden = YES;

    
    for (UIView *view in hashTagView.subviews) {
        
        [view removeFromSuperview];
    }
    
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    self.backgroundColor = [UIColor clearColor];
    
    self.infoDic = rowinfoArr;
    
    ///////////////// 상품이미지 시작 /////////////////
    //19금 제한
    if([NCS([self.infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"]) {
        if( [Common_Util isthisAdultCerted] == NO){
            self.productImage.image =  [UIImage imageNamed:@"prevent19cellimg"];
            self.productImage.hidden = NO;
        }else {
            
            self.imageURL = NCS([self.infoDic objectForKey:@"imageUrl"]);
            if([self.imageURL length] > 0)
            {
                // 이미지 로딩
                self.productImage.hidden = NO;
                [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (isInCache)
                                                      {
                                                          self.productImage.image = fetchedImage;
                                                      }
                                                      else
                                                      {
                                                          self.productImage.alpha = 0;
                                                          self.productImage.image = fetchedImage;
                                                          
                                                          
                                                          
                                                          
                                                          [UIView animateWithDuration:0.2f
                                                                                delay:0.0f
                                                                              options:UIViewAnimationOptionCurveEaseInOut
                                                                           animations:^{
                                                                               
                                                                               self.productImage.alpha = 1;
                                                                               
                                                                           }
                                                                           completion:^(BOOL finished) {
                                                                               
                                                                           }];
                                                      }

                        });
                                                                                                        }
                                              }];
                
                
                
            }
            else
            {
                self.productImage.hidden = YES;
            }
            
            
            
        }
    }
    else
    {
        
        self.imageURL = NCS([self.infoDic objectForKey:@"imageUrl"]);
        if([self.imageURL length] > 0)
        {
            
            self.productImage.hidden = NO;
            // 이미지 로딩
            
            [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                
                if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       if (isInCache)
                                                  {
                                                      self.productImage.image = fetchedImage;
                                                      
                                                  }
                                                  else
                                                  {
                                                      self.productImage.alpha = 0;
                                                      self.productImage.image = fetchedImage;
                                                      
                                                      
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1f
                                                                            delay:0.0f
                                                                          options:UIViewAnimationOptionCurveEaseInOut
                                                                       animations:^{
                                                                           
                                                                           self.productImage.alpha = 1;
                                                                           
                                                                       }
                                                                       completion:^(BOOL finished) {
                                                                           
                                                                       }];
                                                  } 
                    });
                                                  
                                              }
                                          }];
            
            
            
        }
        else
        {
            self.productImage.hidden = YES;
        }
        
    }
    ///////////////// 상품이미지 종료 /////////////////
    
    
    
    
    ////////// 상품명 노출 시작 /////////
    
    self.productName.text = NCS([self.infoDic objectForKey:@"productName"]);
    
    self.productName.text =  [NSString stringWithFormat:@"%@\n ",self.productName.text]; //줄바꿈으로 2라인처리
    
    if(self.productName.text.length > 0)
    {
        self.productName.hidden = NO;
        
    }
    else
    {
        self.productName.hidden = YES;
    }
    
    
    ////////// 상품명 노출 종료 //////////
    
    ///////// 할인율 노출 //////////
    // 할인율 / GS가
    NSString *removeCommadrstr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",NCS([self.infoDic objectForKey:@"discountRate"])]      ];
    
    self.salePriceWDiscountRateTrail.constant = 7;
    if([NCS([self.infoDic objectForKey:@"discountRateText"])  length] > 0 ) {
        //그냥 값만 표시
        self.discountRatePercent.text = NCS([self.infoDic  objectForKey:@"discountRateText"]);
        self.discountRate.hidden = YES;
        self.discountRatePercent.hidden = NO;
    }
    else if(  [Common_Util isThisValidWithZeroStr:removeCommadrstr] == YES) {
        if(NCO([self.infoDic objectForKey:@"discountRate"])) {
            int idiscountRate = [(NSNumber *)[self.infoDic objectForKey:@"discountRate"] intValue];
            
            if(idiscountRate > 0) {
                self.discountRate.text = [NSString stringWithFormat:@"%d", idiscountRate];
                self.discountRatePercent.text = @"%";
                //할인율 표시
                self.discountRate.hidden = NO;
                self.discountRatePercent.hidden = NO;
            }
            else {
                self.discountRate.text = @"";
                self.discountRate.hidden = YES;
                self.discountRatePercent.text = @"";
                self.discountRatePercent.hidden = YES;
                self.salePriceWDiscountRateTrail.constant = 0;
            }
        }
        else {
            //20160630 parksegun discountRate값이 nil이면 해당 영역을 숨긴다.
            //전체 뷰히든
            self.discountRate.text = @"";
            self.discountRate.hidden = YES;
            self.discountRatePercent.text = @"";
            self.discountRatePercent.hidden = YES;
            self.salePriceWDiscountRateTrail.constant = 0;
        }
        
    }
    else {
        //전체 뷰히든
        self.discountRate.text = @"";
        self.discountRate.hidden = YES;
        self.discountRatePercent.text = @"";
        self.discountRatePercent.hidden = YES;
        self.salePriceWDiscountRateTrail.constant = 0;
    }
    
    
    
    //////// 판매금액 노출 시작 ////////
    
    int isalePrice = 0;
    
    if(NCO([self.infoDic objectForKey:@"salePrice"]))
    {
        
        
        // 판매 가격
        NSString *removeCommaspricestr = [Mocha_Util strReplace:@"," replace:@"" string: [NSString stringWithFormat:@"%@",[self.infoDic objectForKey:@"salePrice"]]      ];
        
        
        if( [Common_Util isThisValidWithZeroStr:removeCommaspricestr] == YES){
            
            
            self.salePrice.hidden = NO;
            self.salePriceWon.hidden = NO;
            
            isalePrice = [(NSNumber *)removeCommaspricestr intValue];
            
            self.salePrice.text = [Common_Util commaStringFromDecimal:isalePrice];
            
            
            self.salePriceWon.text  =  NCS([self.infoDic objectForKey:@"exposePriceText"]);
            
        }
        else
        {
            //숫자아님
            self.salePrice.hidden = YES;
            self.salePriceWon.hidden = YES;
            
        }
        
        
    }
    else
    {
        
        self.salePrice.hidden = YES;
        self.salePriceWon.hidden = YES;
    }
    
    //////// 판매금액 노출 종료 ////////
    
    
    /////// 판매수량 노출 시작 ///////
    
    if(NCO([self.infoDic objectForKey:@"saleQuantity"])){
        
        NSString *removeCommaorgstr = [Mocha_Util strReplace:@"," replace:@"" string:NCS([self.infoDic objectForKey:@"saleQuantity"])];
        //숫자가 맞음
        if([Common_Util isThisValidNumberStr:removeCommaorgstr]){
            
            //int saleQuantity = [removeCommaorgstr intValue];
            self.saleCount.text = [NSString stringWithFormat:@"%@", NCS([self.infoDic objectForKey:@"saleQuantity"]) ];
            self.saleCountMsg.text = [NSString stringWithFormat:@"%@ %@", NCS([self.infoDic objectForKey:@"saleQuantityText"]) , NCS([self.infoDic objectForKey:@"saleQuantitySubText"]) ];
            
            
            self.saleCount.hidden = NO;
            self.saleCountMsg.hidden = NO;
            
        }
        //숫자아니거나 0일때 수량text 존재함
        else if(  [NCS([self.infoDic objectForKey:@"saleQuantityText"]) length] > 0)
        {
            
            self.saleCount.hidden = YES;
            self.saleCountMsg.hidden = NO;
            self.saleCount.text = @"";
            self.saleCountMsg.text = NCS([self.infoDic objectForKey:@"saleQuantityText"]);
            
        }
        
        else {
            //숫자가 아니거나 0인경우 사라짐
            self.saleCount.hidden = YES;
            self.saleCountMsg.hidden = YES;
        }
        
        
    }
    else {
        self.saleCount.hidden = YES;
        self.saleCountMsg.hidden = YES;
    }
    
        /////// 판매수량 노출 종료 ///////
    ///// 시간 표시 시작 //////
    //videoTime
     if(NCO([self.infoDic objectForKey:@"videoTime"])){
         self.time.text = NCS([self.infoDic objectForKey:@"videoTime"]);
         self.time.hidden = (self.time.text.length <= 0);
         self.timeView.hidden = (self.time.text.length <= 0);
     }
     else{
         self.time.hidden = YES;
         self.time.text = @"";
         self.timeView.hidden = YES;
         
     }
    
    
    ///// 시간 표시 종료 //////
    
    //////// 해시태그 노출 시작 ////////

    if (NCA([self.infoDic objectForKey:@"productHashTags"]) && [(NSArray *)[self.infoDic objectForKey:@"productHashTags"] count] > 0)
    {
        int count = 0;
        int xPostion = 10;
        for(NSString *strTag in [self.infoDic objectForKey:@"productHashTags"])
        {
            if ([NCS(strTag) length]>0) {
                NSString *hashtag = [NSString stringWithFormat:@"#%@",NCS(strTag)];
                CGSize textSize = [hashtag sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
                [self addViewWithFrame:CGRectMake(xPostion,5,textSize.width + 12,20) andKeyWord:hashtag andTag:count++];
                xPostion = xPostion + textSize.width + 20;
                if((xPostion + textSize.width) >= APPFULLWIDTH) // 너비가 길면 탈출
                    break;
            }
        }
    }

    //////// 해시태그 노출 종료 ////////
   

    
}

// 상품 영역이 눌렸을때
- (IBAction)clickProduct:(id)sender {
    
   [self.target dctypetouchEventTBCell:self.infoDic  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"NHP"];
}

-(void)addViewWithFrame:(CGRect)viewRect andKeyWord:(NSString *)strWord andTag:(NSInteger)btnTag{
        // 다시 개발 해야함.. 이전길이가 다를수 있다..
    UIView *viewBG = [[UIView alloc] initWithFrame:CGRectMake(viewRect.origin.x , viewRect.origin.y,  viewRect.size.width , viewRect.size.height)];

    viewBG.backgroundColor = [Mocha_Util getColor:@"f2f2f2"];
    
    UILabel *lblKeyWord = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, viewRect.size.width, viewRect.size.height)];
    lblKeyWord.textColor = [Mocha_Util getColor:@"666666"];
    lblKeyWord.font = [UIFont systemFontOfSize:13.0];
    lblKeyWord.text = strWord;
    lblKeyWord.textAlignment = NSTextAlignmentCenter;
    lblKeyWord.lineBreakMode = NSLineBreakByClipping;
    
    UIButton *btnGoSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGoSearch.frame = CGRectMake(0.0, 0.0, viewRect.size.width, viewRect.size.height);
    btnGoSearch.tag = btnTag;
    [btnGoSearch addTarget:self action:@selector(clickHashTag:) forControlEvents:UIControlEventTouchUpInside];
    
    [viewBG addSubview:lblKeyWord];
    [viewBG addSubview:btnGoSearch];
    [self.hashTagView addSubview:viewBG];
    
}


- (IBAction)clickHashTag:(id)sender{
    
    if (NCA([self.infoDic objectForKey:@"productHashTags"])) {
        NSArray *arr = [self.infoDic objectForKey:@"productHashTags"];
        // 태그가 눌렸구나~~~~
        NSLog(@"태그: %ld",(long)((UIButton *)sender).tag);
        
        if ([arr count] > [((UIButton *)sender) tag]) {
            NSString *strName = [arr objectAtIndex:[((UIButton *)sender) tag]];
            
            NSLog(@"hashtag: %@",strName);
            
            if ([self.target respondsToSelector:@selector(onBtnHFTag:andCnum:withCallType:)]) {
                NSDictionary *dicTag = [[NSDictionary alloc] initWithObjectsAndKeys:strName,@"productName", nil];
                [self.target onBtnHFTag:dicTag andCnum:[NSNumber numberWithInt:0] withCallType:kNHPCALLTYPE];
            }
        }
        
    }
    
    //wiselog 처리
    
    if (NCA([self.infoDic objectForKey:@"productHashTagWiseLogs"])) {
        NSArray *arr = [self.infoDic objectForKey:@"productHashTagWiseLogs"];
        // 태그가 눌렸구나~~~~
        NSLog(@"태그: %ld",(long)((UIButton *)sender).tag);
        
        if ([arr count] > [((UIButton *)sender) tag]) {
            NSString *wiselog = [arr objectAtIndex:[((UIButton *)sender) tag]];
            
            NSLog(@"hashtag: %@",wiselog);
            
            if([wiselog hasPrefix:@"http://"]) {
                ////탭바제거
                [ApplicationDelegate wiseAPPLogRequest:wiselog];
            }
            
        }
        
    }
    
}

@end
