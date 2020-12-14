//
//  SectionBIMtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 7. 29..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionBIMtypeCell.h"
#import "AppDelegate.h"


@implementation SectionBIMtypeCell

@synthesize thumbnailImage = thumbnailImage_;
@synthesize tvHotIcon = tvHotIcon_;

@synthesize loadingImageURLString = loadingImageURLString_;

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    NSLog(@"");
    
}

-(void) prepareForReuse {
    [super prepareForReuse];
    self.thumbnailImage.image = nil;
    self.loadingImageURLString = nil;
    self.tvHotIcon.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.accessibilityLabel = @"";
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    
    //NSLog(@"인포딕 %@", rowinfoArr);

    self.tvHotIcon.hidden = ![NCS([rowinfoArr objectForKey:@"isTvHot"]) isEqualToString:@"Y"];

    
    // nami0342 - Accessibility
    self.accessibilityTraits = UIAccessibilityTraitButton;
    NSString *strACL = NCS([rowinfoArr objectForKey:@"productName"]);
    
    if(strACL.length > 0)
    {
        self.accessibilityLabel = strACL;
    }
    else
    {
        self.accessibilityLabel = @"이미지 베너 입니다.";
    }
    


    
    self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
    if([self.loadingImageURLString length] > 0){
        
        
        [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache) {
                      
                      self.thumbnailImage.image = fetchedImage;
                  } else {
                      
                      
                      self.thumbnailImage.alpha = 0;
                      self.thumbnailImage.image = fetchedImage;
                      
                      // nami0342 - main thread
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [UIView animateWithDuration:0.2f
                                            delay:0.0f
                                          options:UIViewAnimationOptionCurveEaseInOut
                                       animations:^{
                                           
                                           self.thumbnailImage.alpha = 1;
                                           
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

@end
