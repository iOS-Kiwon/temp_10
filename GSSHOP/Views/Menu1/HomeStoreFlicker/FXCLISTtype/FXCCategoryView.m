//
//  FXCCategoryView.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 22..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "FXCCategoryView.h"
#import "SectionView+FXCLIST.h"

@implementation FXCCategoryView
@synthesize target;

-(id)initWithTarget:(id)sender cate:(NSArray *)arrCate seletedIndex:(NSInteger)index
{
    
    self = [super init];
    if (self)
    {
        
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"FXCCategoryView" owner:self options:nil];
        
        self = [nibs objectAtIndex:0];
        target = sender;

        self.frame = CGRectMake(0, 0, APPFULLWIDTH,self.frame.size.height);
        
        //128 120
        for (NSInteger i = 0 ; i<[arrCate count]; i++) {

            UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
            btnCate.frame = CGRectMake(i*(APPFULLWIDTH/[arrCate count]), 0.0, APPFULLWIDTH/[arrCate count], viewBG.frame.size.height);

            btnCate.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [self setButtonImages:(NSDictionary *)[arrCate objectAtIndex:i] withButton:btnCate];
            
            
            
            btnCate.tag = i;
            [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
            
            [viewBG addSubview:btnCate];
        }
        
        [self setCateIndex:index];
        
    }
    return self;
    
    
    
}


-(void)setButtonImages:(NSDictionary*)dic withButton:(UIButton *)btn{
    
    
    NSString *strURL = NCS([dic objectForKey:@"sectionImgOffUrl"]);
    if([strURL length] > 0){

        
        [ImageDownManager blockImageDownWithURL:strURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [strURL isEqualToString:strInputURL]){
                
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

                });
                              }
      }];
    }
    
    NSString *strURL1 = NCS([dic objectForKey:@"sectionImgOnUrl"]);
    if([strURL1 length] > 0){
    
        [ImageDownManager blockImageDownWithURL:strURL1 responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [strURL1 isEqualToString:strInputURL]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      
                      NSLog(@"Data from cache Image");
                      [btn setImage:fetchedImage forState:UIControlStateHighlighted];
                      [btn setImage:fetchedImage forState:UIControlStateSelected];
                      
                  } else {
                      
                      
                      btn.alpha = 0;
                      [btn setImage:fetchedImage forState:UIControlStateHighlighted];
                      [btn setImage:fetchedImage forState:UIControlStateSelected];
                      
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
                });
                  
            }
      }];    
        
    }else {
        
    }
}

-(void)drawRect:(CGRect)rect {
    
}


- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}





-(void)onBtnCate:(id)sender {
    
    NSLog(@"");

    [(SectionView*)target performSelector:@selector(SELECTEDFXCCATEGORYWITHTAG:) withObject:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] ];

}

-(void)setCateIndex:(NSInteger)indexCategory{
    for (int i=0; i<[[viewBG subviews] count]; i++) {
        UIButton *btnCate = (UIButton *)[[viewBG subviews] objectAtIndex:i];
        btnCate.selected = ([btnCate tag]==indexCategory)?YES:NO;
    }
}


@end
