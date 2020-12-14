//
//  SectionSBTtypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2016. 7. 12..
//  Copyright © 2016년 GS홈쇼핑. All rights reserved.
//

#import "SectionSBTtypeCell.h"
#import "SectionSBTtypeSubview.h"
#import "AppDelegate.h"
#import "Common_Util.h"
#import "NSTFCListTBViewController.h"

@implementation SectionSBTtypeCell

@synthesize defaultView;
@synthesize indexPath;
@synthesize imgSeleted;
@synthesize viewBottomLine;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = self.backColor;
    
    
    /*
    for (UIView *view in self.defaultView.subviews) {
        
        [view removeFromSuperview];
    }
     */
    
    
    
    
    float spaceW = 10;
    float subWidth = (APPFULLWIDTH - (spaceW * 4))/3;
    int xPostion = 10;
    int index = 0;
    
    self.defaultView.frame = CGRectMake(self.defaultView.frame.origin.x, self.defaultView.frame.origin.y, APPFULLWIDTH , (subWidth * 1.774) + 10);
    
    subview01 = [[[NSBundle mainBundle] loadNibNamed:@"SectionSBTtypeSubview" owner:self options:nil] firstObject];
    subview01.target = self;
    subview01.clickButton.tag = index;
    index++;
    subview01.frame = CGRectMake(xPostion, 0, subWidth, (subWidth * 1.774));
    xPostion = xPostion + subWidth + spaceW;
    
    [self.defaultView addSubview:subview01];
    
    subview02 = [[[NSBundle mainBundle] loadNibNamed:@"SectionSBTtypeSubview" owner:self options:nil] firstObject];
    subview02.target = self;
    subview02.clickButton.tag = index;
    index++;
    subview02.frame = CGRectMake(xPostion, 0, subWidth, (subWidth * 1.774));
    xPostion = xPostion + subWidth + spaceW;
    
    [self.defaultView addSubview:subview02];
    
    subview03 = [[[NSBundle mainBundle] loadNibNamed:@"SectionSBTtypeSubview" owner:self options:nil] firstObject];
    subview03.target = self;
    subview03.clickButton.tag = index;
    index++;
    subview03.frame = CGRectMake(xPostion, 0, subWidth, (subWidth * 1.774));
    
    [self.defaultView addSubview:subview03];
    
}


-(void) prepareForReuse {
    [super prepareForReuse];
    self.subArr = nil;

    /*
    for (UIView *view in self.defaultView.subviews)
    {
        
        [view removeFromSuperview];
    }
    */
    self.backgroundColor = self.backColor;
 
    self.indexPath = nil;
    
    subview01.hidden = YES;
    subview02.hidden = YES;
    subview03.hidden = YES;
    
    subview01.productImage.image = nil;
    subview02.productImage.image = nil;
    subview03.productImage.image = nil;
    
}



-(void) setCellInfoNDrawData:(NSDictionary*)rowinfo andIndexPath:(NSIndexPath *)path{
    
    subview01.hidden = YES;
    subview02.hidden = YES;
    subview03.hidden = YES;
    
    self.subArr = [rowinfo objectForKey:@"subProductList"];
    self.indexPath = path;
    
    // 처음 나오는 셀은 상단에 여백이 필요하다.
    NSString *isfirst = [rowinfo objectForKey:@"isFirst"];

    float spaceW = 10;
    float subWidth = (APPFULLWIDTH - (spaceW * 4))/3;
    self.backgroundColor = self.backColor;
    //int xPostion = 10;
    
    if ([isfirst isEqualToString:@"Y"]) {
        self.defaultView.frame = CGRectMake(self.defaultView.frame.origin.x, self.defaultView.frame.origin.y, APPFULLWIDTH , (subWidth * 1.774) + ([isfirst isEqualToString:@"Y"]?20:10));
    }
    
    
    
    
    if ([self.subArr count] > 0) {
        subview01.hidden = NO;
        NSDictionary *subDic = [self.subArr objectAtIndex:0];
        
        if ([isfirst isEqualToString:@"Y"]) {
            subview01.frame = CGRectMake(subview01.frame.origin.x, ([isfirst isEqualToString:@"Y"]?10:0), subview01.frame.size.width, subview01.frame.size.height);
        }
        
        //xPostion = xPostion + subWidth + spaceW;
        [subview01 setCellInfoNDrawData:subDic ];
    }
    
    if ([self.subArr count] > 1) {
        subview02.hidden = NO;
        NSDictionary *subDic = [self.subArr objectAtIndex:1];
        
        if ([isfirst isEqualToString:@"Y"]) {
            subview02.frame = CGRectMake(subview02.frame.origin.x, ([isfirst isEqualToString:@"Y"]?10:0), subview02.frame.size.width, subview02.frame.size.height);
        }
        
        //xPostion = xPostion + subWidth + spaceW;
        [subview02 setCellInfoNDrawData:subDic ];
    }
    
    if ([self.subArr count] > 2) {
        subview03.hidden = NO;
        NSDictionary *subDic = [self.subArr objectAtIndex:2];
        
        if ([isfirst isEqualToString:@"Y"]) {
            subview03.frame = CGRectMake(subview03.frame.origin.x, ([isfirst isEqualToString:@"Y"]?10:0), subview03.frame.size.width, subview03.frame.size.height);
        }
        
        [subview03 setCellInfoNDrawData:subDic ];
    }
   
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)clickProduct:(id)sender withProductImage:(UIImage *)image
{
    
    NSInteger senderTag = [((UIButton *)sender) tag];
    
    if ([self.target respondsToSelector:@selector(touchEventSBTCell:andCnum:andCImage:indexPathCell:withCallType:)]) {
        
        if ([self.subArr count] > senderTag) {
            [self.target touchEventSBTCell:[self.subArr objectAtIndex:senderTag] andCnum:[NSNumber numberWithInt:(int)senderTag] andCImage:image indexPathCell:indexPath withCallType:@"SBT"];
        }
    }
    
    
    
}


@end
