//
//  MobileLiveAdminTalkCell.m
//  GSSHOP
//
//  Created by nami0342 on 20/02/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "MobileLiveAdminTalkCell.h"
#import "MobileLiveViewController.h"
#import <QuartzCore/QuartzCore.h>

// 수정 필요 - 테이블 셀로 xib 만들것
@implementation MobileLiveAdminTalkCell


@synthesize m_lbText = _m_lbText;
@synthesize m_lbName = _m_lbName;
@synthesize m_idParent = _m_idParent;


-(void) prepareForReuse
{
    [super prepareForReuse];
    
    [self.m_lbText setText:@""];
    [self.m_lbName setText:@""];
    self.m_ctNameWidth.constant = 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void) setCellInfoNDrawData : (NSDictionary *) dicData
{
    //'MO' : { 'MG': message, 'EM': 이모티콘 코드 }
    // Message
    NSDictionary *dicMO = [dicData objectForKey:@"MO"];
    NSString *strMG = [dicMO objectForKey:@"MG"];
    
    // User Info
    NSDictionary *dicUO = [dicData objectForKey:@"UO"];
    NSString *strName = NCS([dicUO objectForKey:@"NI"]);
    NSString *strUserNo = NCS([dicUO objectForKey:@"U"]);
    
    BOOL isNormalUser = NO;
    [self layoutIfNeeded];
    
    //
    MobileLiveViewController *idTemp = self.m_idParent;
    if([strUserNo isEqualToString:idTemp.strCSP_ID] == YES)
    {
        [self.m_lbName setBackgroundColor:[Mocha_Util getColor:@"e4e0ff"]];
        [self.m_lbName setTextColor:[UIColor blackColor]];
        [self.m_lbName setText:@"나"];
        [self.m_lbName setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        
        [self.m_bgText setBackgroundColor:[UIColor clearColor]];
        [self.m_lbText setTextColor:[Mocha_Util getColor:@"ffffff"]];
        [self.m_lbText setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium]];
        self.m_ctNameWidth.constant = 20;
        
        [self.m_lbName setAlpha:0.9];
        [self.m_bgText setAlpha:1.0];
        [self layoutIfNeeded];
    }
    else if([strUserNo isEqualToString:@"admin"] == YES)
    {
        [self.m_lbName setTextColor:[UIColor whiteColor]];
        [self.m_lbName setBackgroundColor:[Mocha_Util getColor:@"000000"]];
        [self.m_bgText setBackgroundColor:[Mocha_Util getColor:@"000000"]];
        [self.m_lbText setTextColor:[UIColor whiteColor]];
        [self.m_bgText setAlpha:1.0];
        [self layoutIfNeeded];
        
        // Set name
        if(NCS(strName).length > 0)
        {
            if(strName.length > 2)
            {
                CGSize keyWordSize = [strName MochaSizeWithFont: [UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByClipping];
                self.m_ctNameWidth.constant = keyWordSize.width + 20;
                [self.m_lbName setText:strName];
                [self layoutIfNeeded];
            }
            else if(strName.length == 2)
            {
                self.m_ctNameWidth.constant = 20+10;
                [self.m_lbName setText:strName];
            }
            else
            {
                self.m_ctNameWidth.constant = 20;
                [self.m_lbName setText:strName];
            }
        }
    }
    else
    {
        // Normal user - 들어올 일 없음.
        isNormalUser = YES;
    }
    
    
    if(NCS(strMG).length > 0)
    {
        [self.m_lbText setText:strMG];
    }
    
    if(isNormalUser == YES)
    {
        [self.m_lbName setText:strName];
        [self.m_bgText setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [self.m_lbName.layer setCornerRadius:10];
        [self.m_lbName setClipsToBounds:YES];
        [self.m_bgText.layer setCornerRadius:12];
    }
    [self layoutIfNeeded];
}

@end
