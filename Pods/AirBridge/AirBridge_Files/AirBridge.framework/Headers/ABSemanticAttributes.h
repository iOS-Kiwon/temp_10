//
//  ABSemanticAttributes.h
//  AirBridge
//
//  Created by WOF on 04/03/2019.
//  Copyright © 2019 ab180. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ABData.h"
#import "ABProduct.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABSemanticAttributes : NSObject <ABData>

@property (nonatomic, strong) NSArray<ABProduct*>* products;
@property (nonatomic, strong) NSString* transactionID;
@property (nonatomic, strong) NSNumber* inAppPurchased;
@property (nonatomic, strong) NSString* cartID;
@property (nonatomic, strong) NSString* query;
@property (nonatomic, strong) NSString* productListID;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, strong) NSNumber* totalValue;

@end

NS_ASSUME_NONNULL_END
