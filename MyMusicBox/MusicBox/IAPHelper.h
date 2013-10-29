//
//  IAPHelper.h
//  InAppRage
//
//  Created by Ray Wenderlich on 2/28/11.
//  Copyright 2011 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSSet * _productIdentifiers;    
    NSArray * _products;
    NSMutableSet * _purchasedProducts;
    SKProductsRequest * _request;
//    SKProduct *_classicTheme;
//    SKProduct *_carnivalTheme;
}

@property (nonatomic,retain) NSSet *productIdentifiers;
@property (nonatomic,retain) NSArray * products;
@property (nonatomic,retain) NSMutableSet *purchasedProducts;
@property (nonatomic,retain) SKProductsRequest *request;
//@property (nonatomic,retain) SKProduct *classicTheme;
//@property (nonatomic,retain) SKProduct *carnivalTheme;
- (void)requestProducts;
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProduct:(SKProduct *)product;
- (void)restoreCompletedTransactions;
-(SKProduct *) getSKProductByProductIdentifier:(NSString *) identifier;
@end
