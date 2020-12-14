//
//  SectionSBTtypeSubview.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 11..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionSBTtypeSubview.h"
#import "Common_Util.h"
#import "AppDelegate.h"

@implementation SectionSBTtypeSubview

@synthesize productImage, playIcon, productName,noImage;


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
    self.noImage.hidden = NO;

}



- (void) setCellInfoNDrawData:(NSDictionary*) infoDic
{

    // 상품 이미지 노출 시작

    //19금 제한 적용 v3.1.6.17 20150602~
    if([NCS([infoDic objectForKey:@"adultCertYn"])  isEqualToString:@"Y"] && [Common_Util isthisAdultCerted] == NO) {
        self.productImage.image =  [UIImage imageNamed:@"prevent19cellimg"];
        self.productImage.hidden = NO;
        self.noImage.hidden = YES;
        
    }else {
        
        if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0){
            self.productImage.image = nil;
            
            self.productImage.hidden = NO;
            //self.noImage.hidden = YES;
            // 이미지 로딩
            self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
            
            
            
            
            [ImageDownManager blockImageDownWithURL:self.imageURL isForce:NO useMemory:YES responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isCache, NSError *error) {
            
                if(error == nil && [strInputURL isEqualToString:self.imageURL])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (isCache)
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
        else{
            self.productImage.hidden = YES;
            self.noImage.hidden = NO;
        } 
        
    }
    
    // 상품명 노출 시작
    self.productName.hidden = NO;
    
    NSString *strProductName = NCS([infoDic objectForKey:@"promotionName"]);
    
    CGSize totsize = [strProductName MochaSizeWithFont:self.productName.font constrainedToSize:CGSizeMake(self.frame.size.width - 14.0, 32.0) lineBreakMode:self.productName.lineBreakMode];

    if (totsize.height < 16.0) {
        //상품 제목이 1줄일경우 하단으로 붙히기 위해 뉴라인 처리 추가
        self.productName.text =  [NSString stringWithFormat:@"\n%@",strProductName];
    }else{
        self.productName.text =  strProductName;
    }
    
}

// 동영상을 클릭하면 이벤트 발생
- (IBAction)cellClick:(id)sender {
    NSLog(@"SBT cell Click %ld",(long)[((UIButton *)sender) tag]);
    
    
    [self.target clickProduct:sender withProductImage:self.productImage.image];

    
}
@end
