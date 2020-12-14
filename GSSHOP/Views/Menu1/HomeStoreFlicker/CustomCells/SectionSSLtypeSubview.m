//
//  SectionSSLtypeSubview.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 13..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionSSLtypeSubview.h"
#import "AppDelegate.h"
#import "Common_Util.h"

@implementation SectionSSLtypeSubview


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
}

-(void) prepareForReuse {
    
    self.backgroundColor = [UIColor clearColor];
    self.productName.text = @"";
    self.productName.hidden = YES;
    self.productImage.image = nil;
    self.productImage.hidden = YES;
    self.playIcon.hidden = YES;
    
}



- (void) setCellInfoNDrawData:(NSDictionary*) infoDic
{
    
    // 상품 이미지 노출 시작
    
    //19금 제한 적용 v3.1.6.17 20150602~
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"] && [Common_Util isthisAdultCerted] == NO) {
        self.productImage.image =  [UIImage imageNamed:@"prevent19cellimg"];
        self.productImage.hidden = NO;
        
    }else {
        
        if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0){
            
            self.productImage.hidden = NO;
            // 이미지 로딩
            self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
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
        else{
            self.productImage.hidden = YES;
        }
        
    }
    
    // 상품명 노출 시작
    self.productName.hidden = NO;
    self.productName.text = NCS([infoDic objectForKey:@"promotionName"]);
    
    // 비디오 아이콘 노출여부
    //self.playIcon.hidden =  NO;//![(NSNumber *)[infoDic objectForKey:@"hasVod"] boolValue];
    
    
}




- (id)initWithTarget:(id)sender{
    self = [super init];
    if (self)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SectionSSLtypeSubview" owner:self options:nil];
        if(!NCA(nibs)) return self;
        self = [nibs objectAtIndex:0];
        self.target = sender;
    }
    return self;
}



@end
