//
//  MobileLiveUserTalkCell.m
//  GSSHOP
//
//  Created by nami0342 on 11/02/2019.
//  Copyright © 2019 GS홈쇼핑. All rights reserved.
//

#import "MobileLiveUserTalkCell.h"
#import "MobileLiveViewController.h"

@implementation MobileLiveUserTalkCell



@synthesize m_lbText = _m_lbText;
@synthesize m_lbName = _m_lbName;
@synthesize m_idParent = _m_idParent;


-(void) prepareForReuse
{
    [super prepareForReuse];
    
    [self.m_lbName setText:@""];
    [self.m_lbText setText:@""];
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
    NSString *strName = [dicUO objectForKey:@"NI"];

    

    // Set name to masking
    if(NCS(strName).length > 0)
    {
        // 이미 마스킹된 데이터가 들어오므로 따로 마스킹 작업할 필요 없음.
//        NSArray *arTemp = [strName componentsSeparatedByString:@"@"];
//
//        if([arTemp count] > 1)
//        {
//            NSString *strTemp = [arTemp objectAtIndex:0];
//
//            if(strTemp.length >= 4)
//            {
//                NSRange range = NSMakeRange(2, strTemp.length-2);
//                NSString *stars = [@"" stringByPaddingToLength:(strTemp.length-2) withString:@"*" startingAtIndex:0];
//                strTemp = [strTemp stringByReplacingCharactersInRange:range withString:stars];
//            }
//            else
//            {
//                strTemp = [NSString stringWithFormat:@"%@**", [strTemp substringToIndex:1]];
//            }
//
//            strName = [NSString stringWithFormat:@"%@@%@", strTemp, [arTemp objectAtIndex:1]];
//        }
//        else
//        {
//            if(strName.length >= 6)
//            {
//                NSRange range = NSMakeRange(3, strName.length-3);
//                NSString *stars = [@"" stringByPaddingToLength:(strName.length-3) withString:@"*" startingAtIndex:0];
//                strName = [strName stringByReplacingCharactersInRange:range withString:stars];
//            }
//            else if(strName.length == 4 || strName.length == 5)
//            {
//                NSRange range = NSMakeRange((strName.length -3) , 3);
//                NSString *stars = [@"" stringByPaddingToLength:3 withString:@"*" startingAtIndex:0];
//                strName = [strName stringByReplacingCharactersInRange:range withString:stars];
//            }
//            else
//            {
//                strName =  [NSString stringWithFormat:@"%@**", [strName substringToIndex:1]];
//            }
//        }
        
        [self.m_lbName setText:strName];
    }
    
    
    
    
    if(NCS(strMG).length > 0)
    {
        MobileLiveViewController *idtemp = self.m_idParent;
        
        if(idtemp != nil)
        {
            NSString *strMG = [dicMO objectForKey:@"MG"];
            CGSize labelSize = [strMG sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
            labelSize.width = labelSize.width + 20;
            
            
            if(labelSize.width > idtemp.tvChat.frame.size.width)
            {
                CGRect rect = self.frame;
                rect.size.width = 240;
                self.frame = rect;
                [self layoutIfNeeded];
            }
            else
            {
                CGRect rect = self.frame;
                rect.size.width = labelSize.width;
                self.frame = rect;
                [self layoutIfNeeded];
            }
        }
        
        [self.m_lbText setText:strMG];
//        [self.m_bgText.layer setCornerRadius:12];
        //        [self layoutIfNeeded];
    }
}


@end
