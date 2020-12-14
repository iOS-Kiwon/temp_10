//
//  SectionB_ITtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionB_ITtypeCell.h"
#import "AppDelegate.h"

@implementation SectionB_ITtypeCell

@synthesize imageLoadingOperation;

@synthesize defaultHeight;

@synthesize target;
@synthesize viewDefault;
@synthesize heightTitle;
@synthesize viewTopLine;

@synthesize lblTitle;
@synthesize imgProduct01;
@synthesize lblBrand01;
@synthesize imgProduct02;
@synthesize lblBrand02;
@synthesize imgProduct03;
@synthesize lblBrand03;
@synthesize imgProduct04;
@synthesize lblBrand04;

@synthesize viewProduct01;
@synthesize viewProduct02;
@synthesize viewProduct03;
@synthesize viewProduct04;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    NSLog(@"viewDefault = %@",viewDefault);
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.imgProduct01.image = nil;
    self.imgProduct02.image = nil;
    self.imgProduct03.image = nil;
    self.imgProduct04.image = nil;
    
    
    self.lblBrand01.text = @"";
    self.lblBrand02.text = @"";
    self.lblBrand03.text = @"";
    self.lblBrand04.text = @"";
    
    self.viewProduct01.hidden = YES;
    self.viewProduct02.hidden = YES;
    self.viewProduct03.hidden = YES;
    self.viewProduct04.hidden = YES;
    
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    self.backgroundColor = [UIColor clearColor];
    self.row_arr = [rowinfo objectForKey:@"subProductList"];
    if([NCS([rowinfo objectForKey:@"productName"]) length] > 0) {
        heightTitle.constant = 50.0;
        lblTitle.text = [rowinfo objectForKey:@"productName"];
        viewTopLine.hidden = NO;
    }
    else {
        heightTitle.constant = 10.0;
        lblTitle.text = @"";
        viewTopLine.hidden = YES;
    }
    
    
    CGFloat calHeight;
    NSInteger rowCount = [self.row_arr count]/2;
    calHeight = heightTitle.constant  + ( (int)(((APPFULLWIDTH-30.0)/2.0)*(27.0/29.0) +10.0) * rowCount);
    
    [viewDefault removeConstraint:defaultHeight];
    defaultHeight = [NSLayoutConstraint constraintWithItem:viewDefault
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:NSLayoutAttributeNotAnAttribute
                                       multiplier:1.0
                                         constant:calHeight];
    [viewDefault addConstraint:defaultHeight];
    [viewDefault layoutIfNeeded];
    
    viewProduct01.hidden = YES;
    viewProduct02.hidden = YES;
    viewProduct03.hidden = YES;
    viewProduct04.hidden = YES;
    
    if ([self.row_arr count] > 0) {
        viewProduct01.hidden = NO;
        [self setImageView:imgProduct01 withURL:[[self.row_arr objectAtIndex:0] objectForKey:@"imageUrl"]];
        lblBrand01.text = NCS([[self.row_arr objectAtIndex:0] objectForKey:@"productName"]);
    }
    
    if ([self.row_arr count] > 1) {
        viewProduct02.hidden = NO;
        [self setImageView:imgProduct02 withURL:[[self.row_arr objectAtIndex:1] objectForKey:@"imageUrl"]];
        lblBrand02.text = NCS([[self.row_arr objectAtIndex:1] objectForKey:@"productName"]);
    }
    
    if ([self.row_arr count] > 2) {
        viewProduct03.hidden = NO;
        [self setImageView:imgProduct03 withURL:[[self.row_arr objectAtIndex:2] objectForKey:@"imageUrl"]];
        lblBrand03.text = NCS([[self.row_arr objectAtIndex:2] objectForKey:@"productName"]);
    }
    
    if ([self.row_arr count] > 3) {
        viewProduct04.hidden = NO;
        [self setImageView:imgProduct04 withURL:[[self.row_arr objectAtIndex:3] objectForKey:@"imageUrl"]];
        lblBrand04.text = NCS([[self.row_arr objectAtIndex:3] objectForKey:@"productName"]);
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

-(IBAction)onBtnBrandBanner:(id)sender{
    NSInteger btnTag = [((UIButton *)sender) tag];
    
    if ([self.row_arr count] > btnTag) {
        NSLog(@"[self.row_arr objectAtIndex:btnTag] = %@",[self.row_arr objectAtIndex:btnTag]);
        [target dctypetouchEventTBCell:[self.row_arr objectAtIndex:btnTag] andCnum:[NSNumber numberWithInt:(int)btnTag] withCallType:@"B_IT"];
    }
    
    
    
}
@end
