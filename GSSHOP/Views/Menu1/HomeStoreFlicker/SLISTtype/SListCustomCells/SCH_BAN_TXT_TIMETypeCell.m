//
//  SCH_BAN_TXT_TIMETypeCell.m
//  GSSHOP
//
//  Created by Parksegun on 2017. 4. 18..
//  Copyright © 2017년 GS홈쇼핑. All rights reserved.
//

#import "SCH_BAN_TXT_TIMETypeCell.h"

@implementation SCH_BAN_TXT_TIMETypeCell
@synthesize dateText,infoText1,infoText2,target;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.dateText.text = @"";
    self.infoText1.text = @"";
    self.infoText2.text = @"";
    self.infoText1.hidden = YES;
    self.infoText2.hidden = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.dateText.text = @"";
    self.infoText1.text = @"";
    self.infoText2.text = @"";
    self.infoText1.hidden = YES;
    self.infoText2.hidden = YES;
}

- (void)setCellInfoNDrawData:(NSDictionary*) rowinfoArr{
    
    if(NCO(rowinfoArr)){
        
        celldic = rowinfoArr;

        if (APPFULLWIDTH <= 320.0) {
            self.dateText.font = [UIFont systemFontOfSize:18.0];
            self.infoText1.font = [UIFont systemFontOfSize:12.0];
            self.infoText2.font = [UIFont systemFontOfSize:12.0];
        }
        
        
        
        self.dateText.text = NCS([celldic objectForKey:@"startTime"]);
        self.infoText1.text = NCS([celldic objectForKey:@"liveBenefitLText"]);
        if(self.infoText1.text.length > 0 ){
            self.infoText1.hidden = NO;
        }
        else{
            self.infoText1.hidden = YES;
        }
        
        self.infoText2.text = NCS([celldic objectForKey:@"liveBenefitRText"]);
        if(self.infoText2.text.length > 0 ){
            self.infoText2.hidden = NO;
        }
        else{
            self.infoText2.hidden = YES;
        }

    }
}


- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
}

@end
