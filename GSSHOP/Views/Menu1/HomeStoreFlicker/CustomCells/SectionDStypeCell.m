//
//  SectionDSTypeCell.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 14. 3. 13..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "SectionDStypeCell.h"

#import "AppDelegate.h"

@implementation SectionDStypeCell

@synthesize thumbnailImage = thumbnailImage_;





@synthesize loadingImageURLString = loadingImageURLString_;
//@synthesize imageLoadingOperation = imageLoadingOperation_;


-(void) prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImage.image = nil;
    self.loadingImageURLString = nil;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
       
    self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
    
    [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        
        if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isInCache)
                {
                                                                                  
                      //NSLog(@"Data from cache Image");
                      self.thumbnailImage.image = fetchedImage;
                  }
                else
                  {
                      
                          
                      self.thumbnailImage.alpha = 0;
                      self.thumbnailImage.image = fetchedImage;
                      
                      
                          
                          [UIView animateWithDuration:0.2f
                                                delay:0.0f
                                              options:UIViewAnimationOptionCurveEaseInOut
                                           animations:^{
                                               
                                               self.thumbnailImage.alpha = 1;
                                               
                                           }
                                           completion:^(BOOL finished) {
                                               
                                           }];
                      
                  }
                   
         
            });
        }
        
                                                                              
        
    }];
}

@end
