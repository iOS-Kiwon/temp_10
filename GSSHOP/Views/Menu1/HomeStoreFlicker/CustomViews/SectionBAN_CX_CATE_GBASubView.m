//
//  SectionBAN_CX_CATE_GBASubView.m
//  GSSHOP
//
//  Created by admin on 2018. 6. 25..
//  Copyright © 2018년 GS홈쇼핑. All rights reserved.
//

#import "SectionBAN_CX_CATE_GBASubView.h"
#import "AppDelegate.h"

@implementation SectionBAN_CX_CATE_GBASubView

@synthesize target;

- (void) awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, APPFULLWIDTH, CGRectGetHeight(self.frame));
}

- (void) setCellInfo:(NSDictionary*)infoDic index:(NSInteger)index target:(id)targetId {
    NSArray *arrCate = [infoDic objectForKey:@"subProductList"];
    idxSeleted = index;
    arrCateInfo = arrCate;
    target = targetId;
    
    CGFloat viewBGWidth = APPFULLWIDTH - 20.0 - ([arrCate count] - 1);//여백값1씩을 제외한다.
    CGFloat btnSize = viewBGWidth/[arrCate count];
    CGFloat startPos = 10;
    for (NSInteger i = 0 ; i<[arrCate count]; i++) {
        UIView *viewbtn = [[UIView alloc] initWithFrame:CGRectZero];
        viewbtn.frame = CGRectMake(startPos,10,btnSize, kHEIGHTCATE); // 옆으로 차곡차곡 계산이 필요함
        viewbtn.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
        
        NSDictionary *dicRow = [arrCate objectAtIndex:i];
        UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectZero];
        lblText.textColor = [Mocha_Util getColor:@"444444"];
        lblText.font = [UIFont systemFontOfSize:14.0];
        lblText.text = NCS([dicRow objectForKey:@"productName"]);
        lblText.lineBreakMode = NSLineBreakByClipping;
        lblText.backgroundColor = [UIColor clearColor];
        lblText.frame = CGRectMake(0.0, 0.0, viewbtn.frame.size.width, viewbtn.frame.size.height);
        lblText.textAlignment = NSTextAlignmentCenter;
        lblText.tag = 77;
        [viewbtn addSubview:lblText];
        viewbtn.tag = 500 + i;
        
        UIButton *btnCate = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCate.frame = CGRectMake(0.0, 0.0, viewbtn.frame.size.width, viewbtn.frame.size.height);
        btnCate.tag = i;
        btnCate.accessibilityLabel = NCS([dicRow objectForKey:@"productName"]);
        [btnCate addTarget:self action:@selector(onBtnCate:) forControlEvents:UIControlEventTouchUpInside];
        [viewbtn addSubview:btnCate];
        [self.viewCate addSubview:viewbtn];
        startPos = startPos + btnSize + 1;
    }
    [self setCateIndex:index];
}


- (void)setCateIndex:(NSInteger)indexCategory {
    for (UIView *view in [self.viewCate subviews]) {
        if ([view tag] >= 500) {
            if ([view tag] == (indexCategory + 500)) {
                [self setViewCateStatus:view andSelect:YES];
            }
            else {
                [self setViewCateStatus:view andSelect:NO];
            }
        }
    }
}


-(void)setViewCateStatus:(UIView*)targetView andSelect:(BOOL)isSelected {
    // 선택 배경색 = A4DE00, 폰트 BOLD 444444
    // 비선택 배경색 = F4F4F4 폰트 444444
    targetView.backgroundColor = [UIColor whiteColor];
    UILabel *lblText = [targetView viewWithTag:77]; //label 추출
    if (isSelected) {
        [self bringSubviewToFront:targetView];
        targetView.backgroundColor = [Mocha_Util getColor:@"A4DE00"];
        lblText.font = [UIFont boldSystemFontOfSize:15.0];
    }
    else {
        [self bringSubviewToFront:targetView];
        targetView.backgroundColor = [Mocha_Util getColor:@"F4F4F4"];
        lblText.font = [UIFont systemFontOfSize:14.0];
    }
}


- (void)onBtnCate:(id)sender {
    NSInteger tag = [((UIButton *)sender) tag];
    if (tag == idxSeleted) {
        return;
    }
    NSDictionary *dicRow = [arrCateInfo objectAtIndex:tag];
    if ([self.target respondsToSelector:@selector(onBtnCX_Cate:andCnum:withCallType:)]) {
        [self.target onBtnCX_Cate:dicRow andCnum:[NSNumber numberWithInteger:tag] withCallType:@"BAN_CX_CATE_GBA"];
        idxSeleted = tag;
        [self setCateIndex:tag];

        if([[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"] isKindOfClass:[NSNull class]] == NO && [[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"] hasPrefix:@"http://"]) {
            [ApplicationDelegate wiseAPPLogRequest:[[arrCateInfo objectAtIndex:tag] objectForKey:@"wiseLog"]];
        }
    }
}

@end
