//
//  ThemeIAPHelper.m
//  ThemeIAPHelper 
//
 

#import "ThemeIAPHelper.h"

@implementation ThemeIAPHelper

static ThemeIAPHelper * _sharedHelper;

+ (ThemeIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[ThemeIAPHelper alloc] init];
    return _sharedHelper;
    
}

- (id)init {
    
   //NSSet * productIdentifiers = [NSSet setWithObjects:PRODUCT_IDENTIFIER_CLASSIC,PRODUCT_IDENTIFIER_CARNIVAL,nil];
    
    NSSet * productIdentifiers = [NSSet setWithObjects:nil];
    
    
   if ((self = [super initWithProductIdentifiers:productIdentifiers])) {                
        
    }
    return self;
    
}

+ (BOOL) isInAppPurchaseProduct:(MusicBoxThemeType) type{
    /*
    if(type==CLASSIC
       ||type==CARNIVAL){
        return YES;
    }
     */
    return NO;
}

-(SKProduct *) getSKProductByThemeType:(MusicBoxThemeType) type{
    if(type == CLASSIC){
        return [self getSKProductByProductIdentifier:PRODUCT_IDENTIFIER_CLASSIC];
    }else if(type == CARNIVAL){
        return [self getSKProductByProductIdentifier:PRODUCT_IDENTIFIER_CARNIVAL];
    }else{
        return nil;
    }
}
@end
