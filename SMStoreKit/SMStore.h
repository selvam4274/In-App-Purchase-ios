

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol SMStoreDelegate <NSObject>
@required
-(void)transactionComplete:(NSData *)message;
-(void)transactionFailedWithError:(NSString *)message;
@end

@interface SMStore : NSObject<SKPaymentTransactionObserver> {
	SKPaymentTransaction *tranReceipt;
	id					delegate;
}
@property(nonatomic,assign) id <SMStoreDelegate> delegate;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;
- (void) completeTransaction: (SKPaymentTransaction *)transaction;
- (void) restoreTransaction: (SKPaymentTransaction *)transaction;
@end
