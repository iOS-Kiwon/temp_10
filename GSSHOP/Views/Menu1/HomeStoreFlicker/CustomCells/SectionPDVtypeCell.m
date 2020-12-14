//
//  SectionPDVtypeCell.m
//  GSSHOP
//
//  Created by gsshop iOS on 2016. 5. 18..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionPDVtypeCell.h"
#import "AppDelegate.h"

#import "SectionPDVtypeSubLeft.h"
#import "SectionPDVtypeSubRight.h"

@implementation SectionPDVtypeCell
@synthesize target;
@synthesize viewDefault;
@synthesize viewImgTitle;
@synthesize viewProductAll;

@synthesize imgTitle;

@synthesize imageLoadingOperation;
@synthesize row_arr;

@synthesize viewProductHolder;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor clearColor];
    
}

-(void)prepareForReuse{
    [super prepareForReuse];
    
    for (UIView *view in viewProductHolder.subviews) {
        
        [view removeFromSuperview];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo{
    self.backgroundColor = [UIColor clearColor];
    
    self.row_arr = [rowinfo objectForKey:@"subProductList"];
    
    CGFloat heightTitle = 10.0;
    
    //imageUrl 이 있을경우만 보여짐 , 없으면 hidden 및 프레임 조절
    if ([[rowinfo objectForKey:@"imageUrl"] length] > 0 && [[rowinfo objectForKey:@"imageUrl"] hasPrefix:@"http"]) {
        heightTitle = [Common_Util DPRateOriginVAL:40.0];
        imgTitle.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, [Common_Util DPRateOriginVAL:40.0]);
        [self setImageView:imgTitle withURL:[rowinfo objectForKey:@"imageUrl"]];
        viewImgTitle.hidden = NO;
    }else{
        
        viewImgTitle.hidden = YES;
    }
    
    CGFloat calHeight;
    NSInteger rowCount = [self.row_arr count];
    
    CGFloat fixedValue = (APPFULLWIDTH - 20.0)/2.0;
    calHeight = heightTitle +(fixedValue*rowCount) + 10.0;
    
    
    viewDefault.frame = CGRectMake(0.0, 0.0, APPFULLWIDTH, calHeight);
    viewProductAll.frame = CGRectMake(10.0, heightTitle, (APPFULLWIDTH-20.0), (fixedValue*rowCount));
    viewProductHolder.frame = CGRectMake(0.0, 0.0, (APPFULLWIDTH-20.0), (fixedValue*rowCount));
    
    
    NSLog(@"[self.row_arr count] = %lu",(long)[self.row_arr count]);
    
    
    //SectionPDVtypeSubLeft,SectionPDVtypeSubRight 배치
    for (NSInteger i=0; i<[self.row_arr count]; i++) {
        
        if (i%2 == 0) {
            SectionPDVtypeSubLeft *subCell = [[[NSBundle mainBundle] loadNibNamed:@"SectionPDVtypeSubLeft" owner:self options:nil] firstObject];
            subCell.target = self;
            [subCell setCellInfoNDrawData:[self.row_arr objectAtIndex:i]];
            subCell.idxRow = i;
            
            subCell.frame = CGRectMake(0.0, ((APPFULLWIDTH-20.0)/2.0)*i, APPFULLWIDTH - 20.0, (APPFULLWIDTH-20.0)/2.0);
            
            if (i != 0) {
                subCell.lineTop.hidden = NO;
            }else{
                subCell.lineTop.hidden = YES;
            }
            
            [viewProductHolder addSubview:subCell];
            
            NSLog(@"subCell.frame = %@",NSStringFromCGRect(subCell.frame));
            
            
            
        }else{
            SectionPDVtypeSubRight *subCell = [[[NSBundle mainBundle] loadNibNamed:@"SectionPDVtypeSubRight" owner:self options:nil] firstObject];
            subCell.target = self;
            [subCell setCellInfoNDrawData:[self.row_arr objectAtIndex:i]];
            subCell.idxRow = i;
            
            subCell.frame = CGRectMake(0.0, ((APPFULLWIDTH-20.0)/2.0)*i, APPFULLWIDTH - 20.0, (APPFULLWIDTH-20.0)/2.0);
            [viewProductHolder addSubview:subCell];
            
            NSLog(@"subCell.frame = %@",NSStringFromCGRect(subCell.frame));
            
        }
        
    }

    
    NSLog(@"viewProductHolder.subviews = %@",viewProductHolder.subviews);
    
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

-(IBAction)onBtnBrandBanner:(NSDictionary *)dicSend andIndex:(NSInteger)index{
    
    [target dctypetouchEventTBCell:dicSend andCnum:[NSNumber numberWithInt:(int)index] withCallType:@"PDV"];
}



@end
