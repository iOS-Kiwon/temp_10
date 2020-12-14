//
//  ABEcommerceEvent.h
//  AirBridge
//
//  Created by donutt on 2017. 8. 8..
//  Copyright © 2017년 TehranSlippers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ABInAppEvent.h"
#import "ABProduct.h"

@interface ABEcommerceEvent : ABInAppEvent

@property (nonatomic, strong) NSArray* products;

@property (nonatomic, strong) NSString* productListID;
@property (nonatomic, strong) NSString* query;
@property (nonatomic, strong) NSString* cartID;
@property (nonatomic, strong) NSString* transactionID;
@property (nonatomic, strong) NSNumber* eventValue;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic) BOOL isInAppPurchase;

- (id)initWithProducts:(NSArray<ABProduct*>*)products;

- (void)sendViewHome;
- (void)sendViewProductList;
- (void)sendViewSearchResult;
- (void)sendViewProductDetail;
- (void)sendAddProductToCart;
- (void)sendCompleteOrder;

@end
