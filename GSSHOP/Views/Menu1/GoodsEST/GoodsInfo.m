//
//  GoodsInfo.m
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//  상품평 정보 저장 

#import "GoodsInfo.h"


@implementation GoodsInfo

@synthesize bbsId;
@synthesize brandName;
@synthesize contBytes;
@synthesize contentsFlag;
@synthesize dbsts;
@synthesize ecuserid;
@synthesize eshopid;
@synthesize evalName1;
@synthesize evalName2;
@synthesize evalName3;
@synthesize evalName4;
@synthesize evalValue1;
@synthesize evalValue2;
@synthesize evalValue3;
@synthesize evalValue4;
@synthesize happyTesterId;
@synthesize hidden_name_0;
@synthesize hidden_path_0;
@synthesize isSetPrd;
@synthesize masterId;
@synthesize messageDscr;
@synthesize messageId;
@synthesize messageLevel;
@synthesize ordOption1Nm;
@synthesize ordOption2Nm;
@synthesize ordOptionDispYn;
@synthesize orderNum;
@synthesize pleinPrd;
@synthesize prdImg;
@synthesize prdName;
@synthesize prdTypeCd;
@synthesize prdid;
@synthesize promoNum;
@synthesize promo_num;
@synthesize remark;
@synthesize save_root;
@synthesize setPrdid;
@synthesize testerId;
@synthesize title;
@synthesize errorCode;
@synthesize errorMsg;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.bbsId = @"";
        self.brandName = @"";
        self.contBytes = @"";
        self.contentsFlag = @"";
        self.dbsts = @"";
        self.ecuserid = @"";
        self.eshopid = @"";
        self.evalName1 = @"";
        self.evalName2 = @"";
        self.evalName3 = @"";
        self.evalName4 = @"";
        self.evalValue1 = @"";
        self.evalValue2 = @"";
        self.evalValue3 = @"";
        self.evalValue4 = @"";
        self.happyTesterId = @"";
        self.hidden_name_0 = @"";
        self.hidden_path_0 = @"";
        self.isSetPrd = @"";
        self.masterId = @"";
        self.messageDscr = @"";
        self.messageId = @"";
        self.messageLevel = @"";
        self.ordOption1Nm = @"";
        self.ordOption2Nm = @"";
        self.ordOptionDispYn = @"";
        self.orderNum = @"";
        self.pleinPrd = @"";
        self.prdImg = @"";
        self.prdName = @"";
        self.prdTypeCd = @"";
        self.prdid = @"";
        self.promoNum = @"";
        self.promo_num = @"";
        self.remark = @"";
        self.save_root = @"";
        self.setPrdid = @"";
        self.testerId = @"";
        self.title = @"";
        self.errorCode = @"";
        self.errorMsg = @"";
    }
    return  self;
}
@end
