

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "SMStore.h"
#import "SMSettings.h"


@protocol SMpurchaseDelegate <NSObject>
@required
-(void)purchaseProductSucess;
-(void)purchaseProductFail;
@end

@interface purchaseProduct : NSObject <SMStoreDelegate> {
    
	SMStore *sMStore;
	NSURLConnection *sConnection;
	NSString* newStringCon;
	int ServiceCheck;
	NSData *receipt;
	NSMutableData *dataFromConnection;
	id	delegate;
}

@property(nonatomic,assign) NSString* newStringCon;
@property(nonatomic,assign) id <SMpurchaseDelegate> delegate;
@property (nonatomic, retain) NSData *receipt;

-(void)verifyProductForReviewAccess;
-(void)verifyReceiptOnComplete;
- (void) addReceiptOnComplete;
-(void)verifyDirectApple;
-(void)purchaseProductPayment;
@end
