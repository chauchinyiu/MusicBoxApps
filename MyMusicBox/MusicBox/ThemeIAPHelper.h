//
//  ThemeIAPHelper.h
//  ThemeIAPHelper 
//
 

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface ThemeIAPHelper : IAPHelper {

}

+ (ThemeIAPHelper *) sharedHelper;
+ (BOOL) isInAppPurchaseProduct:(MusicBoxThemeType) type;
-(SKProduct *) getSKProductByThemeType:(MusicBoxThemeType) type;
@end
