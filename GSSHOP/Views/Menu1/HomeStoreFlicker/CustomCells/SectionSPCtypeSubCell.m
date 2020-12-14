//
//  SectionSPCtypeSubCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 11. 20..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionSPCtypeSubCell.h"
#import "HztbGlobalVariables.h"

@implementation SectionSPCtypeSubCell
@synthesize view_Default;
@synthesize imageContents;
@synthesize lblWeek;
@synthesize lblTime;
@synthesize btnCell;
@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    
    
    view_Default.frame = CGRectMake(10.0, 10.0, view_Default.frame.size.width, view_Default.frame.size.height);
    
    [self addSubview:view_Default];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic {

    @try {
        lblWeek.text = [NSString stringWithFormat:@"%@",[[[rowinfoDic objectForKey:@"promotionName"] componentsSeparatedByString:@" "] objectAtIndex:0]];
        lblTime.text = [NSString stringWithFormat:@"%@",[[[rowinfoDic objectForKey:@"promotionName"] componentsSeparatedByString:@" "] objectAtIndex:1]];
    }
    @catch (NSException *exception) {
        NSLog(@"exception = %@",exception);
    }

    
    
    if([[rowinfoDic objectForKey:@"imageUrl"] length] > 0){
        
        self.loadingImageURLString =  NCS([rowinfoDic objectForKey:@"imageUrl"]);
        
        [ImageDownManager blockImageDownWithURL:self.loadingImageURLString responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
            
            if (error == nil  && [self.loadingImageURLString isEqualToString:strInputURL]){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (isInCache)
                                                                              {
                                                                                  self.imageContents.image = fetchedImage;
                                                                              }
                                                                              else
                                                                              {
                                                                                  self.imageContents.alpha = 0;
                                                                                  self.imageContents.image = fetchedImage;
                                                                                  
                                                                                  // nami0342 - main thread
                                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                                      [UIView animateWithDuration:0.2f
                                                                                                        delay:0.0f
                                                                                                      options:UIViewAnimationOptionCurveEaseInOut
                                                                                                   animations:^{
                                                                                                       
                                                                                                       self.imageContents.alpha = 1;
                                                                                                       
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


#pragma mark - Memory Management

- (void)dealloc
{
    self.imageContents = nil;
    self.lblTime = nil;
    
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.imageContents.image = nil;
    self.lblTime.text = @"";
}

@end
