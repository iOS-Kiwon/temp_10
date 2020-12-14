//
//  SectionB_IG4XNtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 3..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_IG4XNtypeCell.h"
#import "AppDelegate.h"

@implementation SectionB_IG4XNtypeCell
@synthesize imgTopBG;
@synthesize viewAllCategory;
@synthesize row_arr,row_dic;
@synthesize target;
@synthesize view_Default;
@synthesize viewBottom;
@synthesize imgBottom;
@synthesize viewCateHLine00;
@synthesize viewCateHLine01;
@synthesize viewCateHLine02;
@synthesize viewCateWLine00;
@synthesize viewCateWLine01;
@synthesize viewCateWLine02;
@synthesize btnBottom;
@synthesize viewMiddle;


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



-(void) setCellInfoNDrawData:(NSMutableDictionary*)rowinfoDic{
    
    self.row_dic = rowinfoDic;
    
    NSLog(@"rowinfoDic = %@",rowinfoDic);
    
    
    
    NSString *imageURL = NCS([self.row_dic objectForKey:@"imageUrl"]);
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
              {
                  self.imgTopBG.image = fetchedImage;
              }
              else
              {
                  self.imgTopBG.alpha = 0;
                  self.imgTopBG.image = fetchedImage;
                  
                  
                  
                  
                  [UIView animateWithDuration:0.2f
                                        delay:0.0f
                                      options:UIViewAnimationOptionCurveEaseInOut
                                   animations:^{
                                       
                                       self.imgTopBG.alpha = 1;
                                       
                                   }
                                   completion:^(BOOL finished) {
                                       
                                   }];
              }
            });
            
            
        }
      }];
    
    
    if (NCA([rowinfoDic objectForKey:@"subProductList"] ) && [(NSArray *)[rowinfoDic objectForKey:@"subProductList"] count] > 0) {
        self.row_arr =  [rowinfoDic objectForKey:@"subProductList"];
        
        
        for (NSUInteger i=1; i<[self.row_arr count]; i++) {
            
            UIButton *btnCate = [viewAllCategory viewWithTag:1000+i];
            btnCate.hidden = NO;
            
            [self setButtonImages:NCS([[self.row_arr objectAtIndex:i] objectForKey:@"imageUrl"]) withButton:btnCate];
            
            int yRow = (int)((i-1)/4);
            int xRow = (i-1)%4 ;
            
            btnCate.frame = CGRectMake(roundf([Common_Util DPRateOriginVAL:80.0])*xRow , roundf([Common_Util DPRateOriginVAL:85.0])*yRow + yRow, roundf([Common_Util DPRateOriginVAL:80.0]), roundf([Common_Util DPRateOriginVAL:85.0]));
            
            if (i==12) {
                break;
            }
        }
        
        
        
        NSLog(@"([self.row_arr count]-1 = %lu",(long)[self.row_arr count]-1);
        
        CGFloat bottomHeight = 0.0;
        
        NSInteger intMultifier = 0;
        if ([self.row_arr count]-1 > 12) {
            intMultifier = 3;
        }else{
            intMultifier = ([self.row_arr count]-1)/4;
        }
        
        if ([[[self.row_arr objectAtIndex:0] objectForKey:@"linkUrl"] length] > 0) {
            
            
            bottomHeight = 40.0;
            
            viewBottom.hidden = NO;
        }else{
            viewBottom.hidden = YES;
        }
        
        
        if (intMultifier == 2) {
            viewCateHLine02.hidden = YES;
        }else if (intMultifier == 1) {
            
            viewCateHLine01.hidden = YES;
            viewCateHLine02.hidden = YES;
        }
        
        imgTopBG.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:60.0]);
        
        viewCateHLine00.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, 1.0);
        
        viewCateHLine01.frame = CGRectMake(0.0, [Common_Util DPRateOriginVAL:85.0], APPFULLWIDTH, 1.0);
        
        viewCateHLine02.frame = CGRectMake(0.0, [Common_Util DPRateOriginVAL:85.0]*2 +1, APPFULLWIDTH, 1.0);
        

        viewCateWLine00.frame = CGRectMake([Common_Util DPRateOriginVAL:80.0], [Common_Util DPRateOriginVAL:60.0], 1.0, roundf([Common_Util DPRateOriginVAL:85.0] *3 ) + intMultifier);
        
        viewCateWLine01.frame = CGRectMake([Common_Util DPRateOriginVAL:80.0]*2, [Common_Util DPRateOriginVAL:60.0], 1, roundf([Common_Util DPRateOriginVAL:85.0] *3 ) + intMultifier);
        
        viewCateWLine02.frame = CGRectMake([Common_Util DPRateOriginVAL:80.0]*3, [Common_Util DPRateOriginVAL:60.0], 1, roundf([Common_Util DPRateOriginVAL:85.0] *3 ) + intMultifier);

        
        viewAllCategory.frame = CGRectMake(0.0, [Common_Util DPRateOriginVAL:60.0], APPFULLWIDTH, roundf([Common_Util DPRateOriginVAL:85.0] *3 ) + intMultifier);
        
        viewMiddle.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, roundf([Common_Util DPRateOriginVAL:60.0] + [Common_Util DPRateOriginVAL:85.0] *intMultifier) +intMultifier);
        
        
        viewBottom.frame = CGRectMake(0.0, viewMiddle.frame.size.height, APPFULLWIDTH, 40.0);
        
        
        
        view_Default.frame = CGRectMake(0.0, 0, APPFULLWIDTH, viewMiddle.frame.size.height + bottomHeight);
        
    }
    
    
    
}


-(void)setButtonImages:(NSString *)imageUrl withButton:(UIButton *)btn{
    
    
    if([imageUrl length] > 0){
        
        
        [ImageDownManager blockImageDownWithURL:imageUrl responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [imageUrl isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      
                      NSLog(@"Data from cache Image");
                      [btn setImage:fetchedImage forState:UIControlStateNormal];
                      
                      
                  } else {
                      
                      
                      btn.alpha = 0;
                      
                      [btn setImage:fetchedImage forState:UIControlStateNormal];
                      
                      // nami0342 - main thread
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           btn.alpha = 1;
                                           
                                       }
                                       completion:^(BOOL finished) {
                                           
                                       }];
                      });
                      
                  }
                  
                  
                  CGFloat xInset = btn.frame.size.width - [Common_Util DPRateOriginVAL:69.0];
                  
                  CGFloat yInset = btn.frame.size.height - [Common_Util DPRateOriginVAL:77.0];
                  
                  [btn setImageEdgeInsets:UIEdgeInsetsMake(yInset/2.0, xInset/2.0, yInset/2.0, xInset/2.0)];
                  [btn setContentMode:UIViewContentModeCenter];

                });
                                  
            }
      }];
        
    }
    else{
        
    }
}


-(void)setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL{
    
    
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [imageURL isEqualToString:strInputURL]){
            dispatch_async(dispatch_get_main_queue(), ^{
               if (isInCache)
              {
                  imgView.image = fetchedImage;
              }
              else
              {
                  imgView.alpha = 0;
                  imgView.image = fetchedImage;
                  
                  
                  
                  
                  [UIView animateWithDuration:0.2f
                                        delay:0.0f
                                      options:UIViewAnimationOptionCurveEaseInOut
                                   animations:^{
                                       
                                       imgView.alpha = 1;
                                       
                                   }
                                   completion:^(BOOL finished) {
                                       
                                   }];
              } 
            });
              
        }
  }];
}


-(void) prepareForReuse {
    
    [super prepareForReuse];
    
    self.imgTopBG.image = nil;
    
    for (id views in viewAllCategory.subviews) {
        if ([views isKindOfClass:[UIButton class]]) {
            UIButton *tempButton = (UIButton *)views;
            tempButton.hidden = YES;
            [tempButton setImage:nil forState:UIControlStateNormal];
        }
    }
    
    
}



-(IBAction)onBtnCateGory:(id)sender
{
    NSLog(@"viewAllCategory.frame = %@",NSStringFromCGRect(viewAllCategory.frame));
    
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:([((UIButton *)sender) tag]-1000)]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]-1000] withCallType:@"B_IG4XN"   ];
    
}

-(IBAction)backGroundButtonClicked:(id)sender{

    
    [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:0]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"B_IG4XNBOTTOM"   ];
    
}


@end
