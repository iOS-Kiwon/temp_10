//
//  SectionB_DHStypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 19..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_DHStypeCell.h"
#import "AppDelegate.h"

@implementation SectionB_DHStypeCell

@synthesize imageLoadingOperation;
@synthesize target;
@synthesize viewBorderImage01;
@synthesize viewBorderImage02;
@synthesize imgProduct01;
@synthesize imgProduct02;

@synthesize imgProductBG01;
@synthesize imgProductBG02;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
    UIColor *borderColor = [Mocha_Util getColor:@"DDDDDD"];
    [viewBorderImage01.layer setMasksToBounds:NO];
    viewBorderImage01.layer.shadowOffset = CGSizeMake(0, 0);
    viewBorderImage01.layer.shadowRadius = 0.0;
    viewBorderImage01.layer.borderColor = borderColor.CGColor;
    viewBorderImage01.layer.borderWidth = 1;
    
    [viewBorderImage02.layer setMasksToBounds:NO];
    viewBorderImage02.layer.shadowOffset = CGSizeMake(0, 0);
    viewBorderImage02.layer.shadowRadius = 0.0;
    viewBorderImage02.layer.borderColor = borderColor.CGColor;
    viewBorderImage02.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    imgProduct01.image = nil;
    imgProduct02.image = nil;
    
    
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    self.row_arr = [rowinfo objectForKey:@"subProductList"];
    
    if ([self.row_arr count] > 0) {
        [self setImageView:imgProduct01 withURL:[[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"]];
    }else{
        imgProduct01.hidden = YES;
        viewBorderImage01.hidden = YES;
        imgProductBG01.hidden = YES;
        
    }
    
    
    if ([self.row_arr count] > 1) {
        [self setImageView:imgProduct02 withURL:[[self.row_arr objectAtIndex:1] objectForKey:@"imageUrl"]];
        imgProduct02.hidden = NO;
        viewBorderImage02.hidden = NO;
        imgProductBG02.hidden = NO;
    }else{
        imgProduct02.hidden = YES;
        viewBorderImage02.hidden = YES;
        imgProductBG02.hidden = YES;
    }
    
    
    

}

-(IBAction)onBtnBanner:(id)sender{
    
    NSLog(@"self.row_arr = %@",self.row_arr);
    
    NSInteger btnTag = [((UIButton *)sender) tag];
    
    if ([self.row_arr count] > btnTag) {
        NSLog(@"[self.row_arr objectAtIndex:btnTag] = %@",[self.row_arr objectAtIndex:btnTag]);
        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:btnTag] andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"B_DHS"];
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

@end
