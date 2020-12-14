//
//  TableHeaderEItypeView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 5. 21..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "TableHeaderEItypeView.h"
#import "Common_Util.h"
#import "AppDelegate.h"


@implementation TableHeaderEItypeView


@synthesize target, productImageView , tag_no1BestDeal;



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    if(getLongerScreenLength == 1024){
        self.productImageView.frame = CGRectMake(0, 0, 320, 160);
    }
    
    
    
    
}

- (id)initWithTarget:(id)sender Nframe:(CGRect)tframe
{
    
    self = [super init];
    if (self)
    {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"TableHeaderEItypeView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        target = sender;
        self.frame = tframe;
    }
    return self;
    
    
    
}


-(void)drawRect:(CGRect)rect {
    
    
    
    
}


-(void) setCellInfoNDrawData:(NSDictionary*) infoDic
{
     
    self.tag_no1BestDeal.hidden = YES;
    
    self.tag_no1BestDeal.hidden = ![NCS([infoDic objectForKey:@"no1DealYn"]) isEqualToString:@"Y"];
    rdic = infoDic;
    if([NCS([infoDic objectForKey:@"imageUrl"]) length] > 0){
        
        
        // 이미지 로딩
        self.imageURL = NCS([infoDic objectForKey:@"imageUrl"]);
        [ImageDownManager blockImageDownWithURL:self.imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.imageURL isEqualToString:strInputURL]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                                              {
                                                  self.productImageView.image = fetchedImage;
                                              }
                                              else
                                              {
                                                  self.productImageView.alpha = 0;
                                                  self.productImageView.image = fetchedImage;
                                                  
                                                  
                                                  
                                                  
                                                  [UIView animateWithDuration:0.2f
                                                                        delay:0.0f
                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                   animations:^{
                                                                       
                                                                       self.productImageView.alpha = 1;
                                                                       
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       
                                                                   }];
                                              }
                });
                
                
                                          }
                                      }];
        
        
        
    }else {
        
        
        
        
    }
    
    
}
-(IBAction)clickEvtwithDic:(id)sender {
    
    //calltype N andCnum 은 GTM 로깅용도
    [target dctypetouchEventTBCell:rdic andCnum:[NSNumber numberWithInt:(int)0] withCallType:@"Sec_TodayDeal"];

    
}
@end
