//
//  DataTVCategoryCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 27..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "DataTVCategoryCell.h"



@implementation DataTVCategoryCell


@synthesize btn_cate1,btn_cate2,btn_cate3,btn_cate4,btn_cate5,btn_cate6,btn_cate7,btn_cate8;
@synthesize imageLoadingOperation;

@synthesize target;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    arrCate = [[NSMutableArray alloc] init];
}



-(void)cellScreenDefine {
    
    
    
}

-(void) prepareForReuse {
    self.backgroundColor = [UIColor clearColor];
    [super prepareForReuse];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




-(void) setCellInfoNDrawData:(NSDictionary*) infoDic
{
    
    
    if(NCA([infoDic objectForKey:@"subProductList"]) && [(NSArray *)[infoDic objectForKey:@"subProductList"] count] >= 8){
        btn_cate1.center = CGPointMake(APPFULLWIDTH/8, btn_cate1.center.y);
        btn_cate2.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4), btn_cate2.center.y);
        btn_cate3.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4)*2, btn_cate3.center.y);
        btn_cate4.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4)*3, btn_cate4.center.y);
        
        btn_cate5.center = CGPointMake(APPFULLWIDTH/8, btn_cate5.center.y);
        btn_cate6.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4), btn_cate6.center.y);
        btn_cate7.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4)*2, btn_cate7.center.y);
        btn_cate8.center = CGPointMake(APPFULLWIDTH/8+(APPFULLWIDTH/4)*3, btn_cate8.center.y);
        
        
        [arrCate removeAllObjects];
        [arrCate addObjectsFromArray:[infoDic objectForKey:@"subProductList"]];
        
        [self setButtonImages:[[arrCate objectAtIndex:0] objectForKey:@"imageUrl"] withButton:btn_cate1];
        [self setButtonImages:[[arrCate objectAtIndex:1] objectForKey:@"imageUrl"] withButton:btn_cate2];
        [self setButtonImages:[[arrCate objectAtIndex:2] objectForKey:@"imageUrl"] withButton:btn_cate3];
        [self setButtonImages:[[arrCate objectAtIndex:3] objectForKey:@"imageUrl"] withButton:btn_cate4];
        
        [self setButtonImages:[[arrCate objectAtIndex:4] objectForKey:@"imageUrl"] withButton:btn_cate5];
        [self setButtonImages:[[arrCate objectAtIndex:5] objectForKey:@"imageUrl"] withButton:btn_cate6];
        [self setButtonImages:[[arrCate objectAtIndex:6] objectForKey:@"imageUrl"] withButton:btn_cate7];
        [self setButtonImages:[[arrCate objectAtIndex:7] objectForKey:@"imageUrl"] withButton:btn_cate8];
        
        NSLog(@"[[arrCate objectAtIndex:0] objectForKey:imageUrl] = %@",[[arrCate objectAtIndex:0] objectForKey:@"imageUrl"]);
        
        [btn_cate1 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate2 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate3 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate4 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate5 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate6 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate7 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btn_cate8 addTarget:self action:@selector(ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}





-(void)setButtonImages:(NSString *)imageUrl withButton:(UIButton *)btn{
    
    if([NCS(imageUrl) length] > 0){
        
        
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
                    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
                });
                
                  
                  
                   
            }
            
          }];
        
    }
    else{
        
    }
}




-(IBAction)ButtonClicked:(id)sender{
    
    [target dctypetouchEventTBCell:[arrCate objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"SUB_SEC"];
}


@end








