//
//  GoodsInfo.h
//  GSSHOP
//
//  Created by uinnetworks on 11. 7. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GoodsInfo : NSObject {

    NSString *bbsId;
    NSString *brandName;
    NSString *contBytes;
    NSString *contentsFlag;//첨부파일구분
    NSString *dbsts;
    NSString *ecuserid;//-----------------필수 
    NSString *eshopid;
    NSString *evalName1;//평가항목1
    NSString *evalName2;//평가항목2
    NSString *evalName3;//평가항목3
    NSString *evalName4;//평가항목4
    NSString *evalValue1;//평가항목1
    NSString *evalValue2;//평가항목2
    NSString *evalValue3;//평가항목3
    NSString *evalValue4;//평가항목4
    NSString *happyTesterId;
    NSString *hidden_name_0;
    NSString *hidden_path_0;
    NSString *isSetPrd;
    NSString *masterId;
    NSString *messageDscr;//상품상세
    NSString *messageId;
    NSString *messageLevel;
    NSString *ordOption1Nm;//주문옵션 1
    NSString *ordOption2Nm;//주문옵션 2
    NSString *ordOptionDispYn;//구매옵션노출여부
    NSString *orderNum;//주문번호
    NSString *pleinPrd;
    NSString *prdImg;
    NSString *prdName;//상품명
    NSString *prdTypeCd;
    NSString *prdid; //상품번호 -------------필수 
    NSString *promoNum;
    NSString *promo_num;//프로모션번호
    NSString *remark;//해피테스트일경우(N)
    NSString *save_root;//고객저장경로
    NSString *setPrdid;
    NSString *testerId;
    NSString *title;//----------------필수 
    
    NSString *errorCode;
    NSString *errorMsg;
    //NSString *messageId;
}

@property (nonatomic,strong)NSString *bbsId;
@property (nonatomic,strong)NSString *brandName;
@property (nonatomic,strong)NSString *contBytes;
@property (nonatomic,strong)NSString *contentsFlag;
@property (nonatomic,strong)NSString *dbsts;
@property (nonatomic,strong)NSString *ecuserid;
@property (nonatomic,strong)NSString *eshopid;
@property (nonatomic,strong)NSString *evalName1;
@property (nonatomic,strong)NSString *evalName2;
@property (nonatomic,strong)NSString *evalName3;
@property (nonatomic,strong)NSString *evalName4;
@property (nonatomic,strong)NSString *evalValue1;
@property (nonatomic,strong)NSString *evalValue2;
@property (nonatomic,strong)NSString *evalValue3;
@property (nonatomic,strong)NSString *evalValue4;
@property (nonatomic,strong)NSString *happyTesterId;
@property (nonatomic,strong)NSString *hidden_name_0;
@property (nonatomic,strong)NSString *hidden_path_0;
@property (nonatomic,strong)NSString *isSetPrd;
@property (nonatomic,strong)NSString *masterId;
@property (nonatomic,strong)NSString *messageDscr;
@property (nonatomic,strong)NSString *messageId;
@property (nonatomic,strong)NSString *messageLevel;
@property (nonatomic,strong)NSString *ordOption1Nm;
@property (nonatomic,strong)NSString *ordOption2Nm;
@property (nonatomic,strong)NSString *ordOptionDispYn;
@property (nonatomic,strong)NSString *orderNum;
@property (nonatomic,strong)NSString *pleinPrd;
@property (nonatomic,strong)NSString *prdImg;
@property (nonatomic,strong)NSString *prdName;
@property (nonatomic,strong)NSString *prdTypeCd;
@property (nonatomic,strong)NSString *prdid;
@property (nonatomic,strong)NSString *promoNum;
@property (nonatomic,strong)NSString *promo_num;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *save_root;
@property (nonatomic,strong)NSString *setPrdid;
@property (nonatomic,strong)NSString *testerId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *errorCode;
@property (nonatomic,strong)NSString *errorMsg;

@end
