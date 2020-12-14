//
//  SectionEItypePSCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 8. 25..
//  Copyright (c) 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionEItypePSCell.h"
#import "AppDelegate.h"

@implementation SectionEItypePSCell

@synthesize thumbnailImage = thumbnailImage_;
@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;

@synthesize imgIconHot = _imgIconHot;
@synthesize imgIconBene = _imgIconBene;
@synthesize imgIconComm = _imgIconComm;
@synthesize noImageE_N1 =_noImageE_N1;
@synthesize noImageE_N2 = _noImageE_N2;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
}

-(void) prepareForReuse {
    
    self.thumbnailImage.image = nil;
    self.loadingImageURLString = nil;
    self.backgroundColor = [UIColor clearColor];
    [self.imageLoadingOperation cancel];
    
    self.imgIconBene.hidden = YES;
    self.imgIconHot.hidden = YES;
    self.imgIconComm.hidden = YES;
    
    [super prepareForReuse];
    
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoArr {
    
    self.thumbnailImage.image = nil;
    self.loadingImageURLString = nil;
    self.backgroundColor = [UIColor clearColor];
    
    self.imgIconHot.hidden = YES;
    self.imgIconBene.hidden = YES;
    self.imgIconComm.hidden = YES;
    
    if ([NCS([rowinfoArr objectForKey:@"viewType"]) isEqualToString:@"E_N1"]){
        self.noImageE_N1.hidden = NO;
        self.noImageE_N2.hidden = YES;
    }else{
        self.noImageE_N1.hidden = YES;
        self.noImageE_N2.hidden = NO;
    }
    
    if ([rowinfoArr objectForKey:@"imgBadgeCorner"] != nil) {
        NSDictionary *dicCorner = [rowinfoArr objectForKey:@"imgBadgeCorner"];
        
        for (NSInteger i = 0 ; i<[dicCorner.allKeys count]; i++) {
            
            
            if ([(NSArray *)[dicCorner objectForKey:[dicCorner.allKeys objectAtIndex:i]] count] > 0) {
                NSDictionary *dicVailedCorner = [(NSArray *)[dicCorner objectForKey:[dicCorner.allKeys objectAtIndex:i]] objectAtIndex:0];
                
                UIImageView *imgToShow = nil;
                
                if ([NCS([dicVailedCorner objectForKey:@"type"]) isEqualToString:@"hot"]) {
                    self.imgIconHot.hidden = NO;
                    imgToShow = self.imgIconHot;
                }else if ([NCS([dicVailedCorner objectForKey:@"type"]) isEqualToString:@"bene"]) {
                    self.imgIconBene.hidden = NO;
                    imgToShow = self.imgIconBene;
                }else if ([NCS([dicVailedCorner objectForKey:@"type"]) isEqualToString:@"comm"]) {
                    self.imgIconComm.hidden = NO;
                    imgToShow = self.imgIconComm;
                }
                
                if ([NCS([dicCorner.allKeys objectAtIndex:i]) isEqualToString:@"LT"]) {
                    imgToShow.frame = CGRectMake(1.0, 1.0, imgToShow.frame.size.width, imgToShow.frame.size.height);
                }else if ([NCS([dicCorner.allKeys objectAtIndex:i]) isEqualToString:@"RT"]) {
                    imgToShow.frame = CGRectMake(self.frame.size.width - imgToShow.frame.size.width, 0.0, imgToShow.frame.size.width, imgToShow.frame.size.height);
                }else if ([NCS([dicCorner.allKeys objectAtIndex:i]) isEqualToString:@"LB"]) {
                    imgToShow.frame = CGRectMake(0.0, self.frame.size.height - imgToShow.frame.size.height, imgToShow.frame.size.width, imgToShow.frame.size.height);
                }else if ([NCS([dicCorner.allKeys objectAtIndex:i]) isEqualToString:@"RB"]) {
                    imgToShow.frame = CGRectMake(self.frame.size.width - imgToShow.frame.size.width, self.frame.size.height - imgToShow.frame.size.height, imgToShow.frame.size.width, imgToShow.frame.size.height);
                }
                
                break;
            }

        }
        
    }
    
    
    if([[rowinfoArr objectForKey:@"imageUrl"] length] > 0){
    
        [self.imageLoadingOperation cancel];
        
        self.loadingImageURLString =  NCS([rowinfoArr objectForKey:@"imageUrl"]);
        
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
