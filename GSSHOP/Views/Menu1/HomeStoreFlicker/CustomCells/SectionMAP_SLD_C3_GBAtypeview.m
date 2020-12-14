//  SectionMAP_SLD_C3_GBAtypeview.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 2. 9..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.

#import "SectionMAP_SLD_C3_GBAtypeview.h"
#import "SectionMAP_SLD_C3_GBAtypeSubview.h"
#import "SectionMAP_SLD_C3_GBAtypeCell.h"


@implementation SectionMAP_SLD_C3_GBAtypeview

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    
    self.threeDealViewWidth.constant = APPFULLWIDTH;
    self.threeDealViewHeight.constant = floor([Common_Util DPRateOriginVAL:93] + 100);
    [self.viewThreeDeal layoutIfNeeded];
    self.bImageHeigth.constant = floor([Common_Util DPRateOriginVAL:218]);
    [self.bImage layoutIfNeeded];
    
    self.sub1 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    self.sub2 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    self.sub3 = (SectionMAP_SLD_C3_GBAtypeSubview *)[[[NSBundle mainBundle] loadNibNamed:@"SectionMAP_SLD_C3_GBAtypeSubview" owner:self options:nil] firstObject];
    [self.viewThreeDeal addSubview:self.sub1];
    [self.viewThreeDeal addSubview:self.sub2];
    [self.viewThreeDeal addSubview:self.sub3];
    self.subArray = [[NSArray alloc] initWithObjects:self.sub1,self.sub2,self.sub3, nil];
}


-(void) prepareForReuse {
    self.backgroundColor = [UIColor whiteColor];
    self.bImage.image = nil;
    for (SectionMAP_SLD_C3_GBAtypeSubview* subview in self.viewThreeDeal.subviews) {        
        [subview prepareForReuse];
        subview.hidden = YES;
    }
}


-(void) setCellInfoNDrawData:(NSDictionary*) rowinfo {
    //데이터 확인후 렌더링(1개에 대해서만)
    if(NCO(rowinfo) && ![NCS([rowinfo objectForKey:@"imageUrl"]) isEqualToString:@""] && NCA([rowinfo objectForKey:@"subProductList"]) == YES) {
        self.row_dic = rowinfo;
        [self setImageView:self.bImage withURL:[self.row_dic objectForKey:@"imageUrl"]];
        [self subThreeDeals:[self.row_dic objectForKey:@"subProductList"]];
    }
}


-(IBAction)topBannerButtonClicked:(id)sender {
    [self.target dellClick:self.row_dic andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag] ]withCallType:@"MAP_SLD_C3_GBA"];
}


-(void)dealButtonClicked:(id)sender {
    [self.target dellClick:[[self.row_dic objectForKey:@"subProductList"] objectAtIndex:[((UIButton *)sender) tag]]  andCnum:[NSNumber numberWithInt:(int)[((UIButton *)sender) tag] ]withCallType:@"MAP_SLD_C3_GBA"];
}


-(void)setImageView:(UIImageView *)imgView withURL:(NSString *)imageURL {
    [ImageDownManager blockImageDownWithURL:imageURL responseBlock:^(NSInteger httpStatusCode, UIImage *fetchedImage, NSString *strInputURL, NSNumber *isInCache, NSError *error) {
        if(error == nil  && [imageURL isEqualToString:strInputURL]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(isInCache) {
                    imgView.image = fetchedImage;
                }
                else {
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


- (void)subThreeDeals:(NSArray *)subProduct {
    float rlmargin = 5;
    /*하단 3개 상품*/
    //왼쪽 정렬
    if(NCA(subProduct)) {
        float itemSize = (self.viewThreeDeal.frame.size.width-(rlmargin*2))/3;
        float xPos = (self.viewThreeDeal.frame.size.width-(rlmargin*2))/6;
        int count = 0;
        for (NSDictionary*subItem in subProduct) {
            SectionMAP_SLD_C3_GBAtypeSubview *sub1 = [self.subArray objectAtIndex:count];
            [sub1 setCellInfoNDrawData:subItem];
            sub1.frame = CGRectMake(0, 0, itemSize, self.viewThreeDeal.frame.size.height);
            sub1.center = CGPointMake(xPos + rlmargin, sub1.frame.size.height/2);
            xPos = xPos + itemSize;
            [sub1.clickButton addTarget:self action:@selector(dealButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            sub1.clickButton.tag = count;
            sub1.hidden = NO;
            count++;
        }
    }
}


@end
