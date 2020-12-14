//
//  AppPushNoneImgCellTableViewCell.m
//  GSSHOP
//
//  Created by KIM HOECHEON on 2014. 10. 20..
//  Copyright (c) 2014년 GS홈쇼핑. All rights reserved.
//

#import "AppPushImgCellTableViewCell.h"
#import "AppPushConstants.h"
#import "AppPushUtil.h"
#import "Common_Util.h"
 
@implementation AppPushImgCellTableViewCell


@synthesize imagebannerView;
- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    
}

-(void) prepareForReuse {
    
    
    
    lblMap1.text = @"";
    
    lblMap2.text = @"";
    
    lblDate.text = @"";
     self.imagebannerView.image = nil;
    
    self.backgroundColor = [UIColor clearColor];
    
    
    [super prepareForReuse];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setData:(NSDictionary *)argData {
    @try {
        
        //[lblMap1 setFrame:CGRectMake(8.0f, 15.0f, APPFULLWIDTH-20, 20.0f)];
        //[lblMap2 setFrame:CGRectMake(8.0f, 32.0f, APPFULLWIDTH-20, 50.0f)];
        //[lblDate setFrame:CGRectMake(8.0f, 80.0f, APPFULLWIDTH-20, 18.0f)];
        
        
        if([@"Y" isEqualToString:[argData valueForKey:AMAIL_MSG_READ_YN]]) {
            isRead = YES;
        } else {
            isRead = NO;
        }
        //NSData *data = [[argData description] dataUsingEncoding:NSUTF8StringEncoding];
        //NSLog(@"msg DATA: %@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] );
        NSString *maintxtcolorstr = [argData valueForKey:AMAIL_MSG_ICON_NAME]!=nil?[self colorstrwithicon:[argData valueForKey:AMAIL_MSG_ICON_NAME]]:@"86CF00";
        
        if(isRead){
            [lblMap1 setTextColor:[Mocha_Util getColor:@"ACACAC"]];
            [lblMap2 setTextColor:[Mocha_Util getColor:@"ACACAC"]];
            [lblDate setTextColor:[Mocha_Util getColor:@"ACACAC"]];
            
            //[ivIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"PMS.bundle/image/pms_%@_gray.png",[imgName stringByReplacingOccurrencesOfString:@".png" withString:@""]]]];
            // NSLog(@" %@ %@",maintxtcolorstr, [NSString stringWithFormat:@"PMS.bundle/image/pms_%@.png",[imgName stringByReplacingOccurrencesOfString:@".png" withString:@"_gray"]]);
        }else {
            
            
            [lblMap1 setTextColor:[Mocha_Util getColor:maintxtcolorstr]];
            [lblMap2 setTextColor:[Mocha_Util getColor:@"444444"]];
            [lblDate setTextColor:[Mocha_Util getColor:@"ACACAC"]];
            
            // [ivIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"PMS.bundle/image/pms_%@.png",[imgName stringByReplacingOccurrencesOfString:@".png" withString:@""]]]];
            // NSLog(@" %@ %@",maintxtcolorstr, [NSString stringWithFormat:@"PMS.bundle/image/pms_%@.png"]);
        }
        
        /*
         NSString *strMap2 = [argData valueForKey:AMAIL_MSG_MAP2];
         if(strMap2!=nil && strMap2.length>0) {
         [lblMap1 setFrame:CGRectMake(62.0f, 6.0f, 250.0f, 21.0f)];
         [lblMap2 setHidden:NO];
         [lblMap1 setNumberOfLines:1];
         [lblMap1 setText:[argData valueForKey:AMAIL_MSG_MAP1]];
         [lblMap2 setText:[argData valueForKey:AMAIL_MSG_MAP2]];
         } else {
         [lblMap1 setFrame:CGRectMake(62.0f, 6.0f, 250.0f, 52.0f)];
         [lblMap2 setHidden:YES];
         [lblMap1 setNumberOfLines:2];
         [lblMap1 setText:[argData valueForKey:AMAIL_MSG_MAP1]];
         }
         */
        //각 1줄 ... fix
        
        [lblMap1 setText:[argData valueForKey:AMAIL_MSG_MAP1]];
        [lblMap1 setNumberOfLines:1];
        [lblMap2 setText:[argData valueForKey:AMAIL_MSG_MAP2]];
        [lblMap2 setNumberOfLines:2];
        
        /*
         NSString *strMap2 = [argData valueForKey:AMAIL_MSG_MAP2];
         if(strMap2!=nil && strMap2.length>0) {
         [lblMap1 setFrame:CGRectMake(62.0f, 6.0f, 250.0f, 21.0f)];
         [lblMap2 setHidden:NO];
         [lblMap1 setNumberOfLines:1];
         [lblMap1 setText:[argData valueForKey:AMAIL_MSG_MAP1]];
         [lblMap2 setText:[argData valueForKey:AMAIL_MSG_MAP2]];
         } else {
         [lblMap1 setFrame:CGRectMake(62.0f, 6.0f, 250.0f, 52.0f)];
         [lblMap2 setHidden:YES];
         [lblMap1 setNumberOfLines:2];
         [lblMap1 setText:[argData valueForKey:AMAIL_MSG_MAP1]];
         }
         */
        
        
        
        
        
        [self setDate:[argData objectForKey:AMAIL_MSG_REG_DATE]];
        
        //푸시이미지 있는 셀일경우 이미지
        if(![@"" isEqualToString:[argData valueForKey:AMAIL_MSG_MAP3]]){
            
           // self.imagebannerView = [[FXImageView alloc] initWithFrame:CGRectMake(8.0, 110.0, APPFULLWIDTH-16, 150.0)];
            
          //  self.imagebannerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
            
            
            //self.imagebannerView.asynchronous = YES;
            //[self.imagebannerView addObserver:self forKeyPath:@"processedImage" options:0 context:NULL];
            
            
            self.indicatorImage.center = self.imagebannerView.center;
            [self.indicatorImage startAnimating];
            
            if([NCS([argData valueForKey:AMAIL_MSG_MAP3]) length] > 0) {
                // 이미지 로딩
                NSString *imageURL = NCS([argData valueForKey:AMAIL_MSG_MAP3]);
                [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
                    
                    
                    if(error == nil  && [imageURL isEqualToString:strInputURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.indicatorImage stopAnimating];
                            
                            if(isInCache) {
                                self.imagebannerView.image = fetchedImage;
                            }
                            else {
                                self.imagebannerView.alpha = 0;
                                self.imagebannerView.image = fetchedImage;
                            }
                            
                            [UIView animateWithDuration:0.2f
                                                  delay:0.0f
                                                options:UIViewAnimationOptionCurveEaseInOut
                                             animations:^{
                                                 self.imagebannerView.alpha = 1;
                                             }
                                             completion:^(BOOL finished) {
                                                 
                                             }];
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.indicatorImage stopAnimating];
                        });
                    }
                }];
            }

            
            [self.imagebannerView.layer setMasksToBounds:NO];
            self.imagebannerView.layer.shadowOffset = CGSizeMake(0, 0);
            self.imagebannerView.layer.shadowRadius = 0.0;
            self.imagebannerView.layer.borderColor = [Mocha_Util getColor:@"E3E3E3"].CGColor;
            self.imagebannerView.layer.borderWidth = ([Common_Util isWide4])?0.5:1.0;;
        }

        
        
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView contentBinding : %@", exception);
    }
    @finally {
    }
}




-(NSString*)colorstrwithicon:(NSString*)argCode {
    NSLog(@"  icon_msg_18%@", argCode);
    
    if(argCode == nil || [NCS(argCode) length] == 0)
        return @"86CF00";
    
    NSArray *curarr = [Mocha_Util explode:@"_" string:argCode];
    
    
    
    int lastcode = [[curarr lastObject] intValue];
    
    if(lastcode < 4 || lastcode == 20){
        
        return @"86CF00";
    }else if (lastcode > 3 && lastcode < 11){
        return @"EE1F60";
    }else if (lastcode > 10 && lastcode < 17){
        return @"00AEBD";
    }else if (lastcode > 16 && lastcode < 20){
        return @"EE1F60";
    }else if( lastcode == 21) {
        return @"86CF00";
    }else {
        return @"86CF00";
    }
}
- (void)setDate:(NSString *)argDate {
    @try {
        [lblDate setText:[AppPushUtil calcDate:argDate
                                  originFormat:@"yyyyMMddHHmmss"
                                     newFormat:@"yyyy.MM.dd a hh:mm"
                                        locale:nil
                                      amSymbol:@"오전"
                                      pmSymbol:@"오후"]];
        
        /*
         [lblDate setText:[AppPushUtil calcDate:argDate
         originFormat:@"yyyyMMddHHmmss"
         newFormat:@"yyyy.MM.dd a h:mm"
         locale:nil
         amSymbol:@"오전"
         pmSymbol:@"오후"]];
         */
        
        NSLog(@"   %f", self.frame.size.height);
    }
    @catch (NSException *exception) {
        NSLog(@"PMS Exception at AppPushBubbleCommonCellView setDate : %@", exception);
    }
}


@end
