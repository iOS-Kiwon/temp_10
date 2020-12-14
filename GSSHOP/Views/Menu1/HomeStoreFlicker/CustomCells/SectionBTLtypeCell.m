//
//  SectionBTLtypeCell.m
//  GSSHOP
//
//  Created by gsshop on 2015. 12. 9..
//  Copyright © 2015년 GS홈쇼핑. All rights reserved.
//

#import "SectionBTLtypeCell.h"
#import "AppDelegate.h"

@implementation SectionBTLtypeCell
@synthesize view_Default;
@synthesize imgProduct01;
@synthesize imgProduct02;
@synthesize lblProgramTitle01;
@synthesize lblProgramTitle02;
@synthesize lblSubject01;
@synthesize lblSubject02;
@synthesize lblDesc01;
@synthesize lblDesc02;
@synthesize imgHeight;
@synthesize imageLoadingOperation;
@synthesize row_dic;
@synthesize target;

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    imgHeight.constant = [Common_Util DPRateOriginVAL:62.0];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfoDic{
    NSLog(@"rowinfoDicrowinfoDic = %@",rowinfoDic);
    
    self.row_dic = rowinfoDic;
    
    @try {
        NSArray *arrSub = [self.row_dic objectForKey:@"subProductList"];
        
        [self setImageView:imgProduct01 withURL:[[arrSub objectAtIndex:0] objectForKey:@"imageUrl"]];
        lblProgramTitle01.text = [[arrSub objectAtIndex:0] objectForKey:@"productName"];
        lblSubject01.text = [[arrSub objectAtIndex:0] objectForKey:@"promotionName"];
        lblDesc01.text = [[arrSub objectAtIndex:0] objectForKey:@"saleQuantityText"];
        
        [self setImageView:imgProduct02 withURL:[[arrSub objectAtIndex:1] objectForKey:@"imageUrl"]];

        lblProgramTitle02.text = [[arrSub objectAtIndex:1] objectForKey:@"productName"];
        lblSubject02.text = [[arrSub objectAtIndex:1] objectForKey:@"promotionName"];
        lblDesc02.text = [[arrSub objectAtIndex:1] objectForKey:@"saleQuantityText"];
        
    }
    @catch (NSException *exception) {
        NSLog(@"exceptionexceptionexception = %@",exception);
        
        return;
    }
    
}


-(void)prepareForReuse{
    [super prepareForReuse];
    imgProduct01.image = nil;
    imgProduct02.image = nil;
    
    lblProgramTitle01.text = @"";
    lblProgramTitle02.text = @"";
    lblSubject01.text = @"";
    lblSubject02.text = @"";
    lblDesc01.text = @"";
    lblDesc02.text = @"";
    
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

-(IBAction)onBtnContents:(id)sender{
    
    NSArray *arrSub = [self.row_dic objectForKey:@"subProductList"];
    
    [target dctypetouchEventTBCell:[arrSub objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag]] withCallType:@"BTL"   ];
}


@end
