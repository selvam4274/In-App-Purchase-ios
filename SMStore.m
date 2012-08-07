
#import "SMStore.h"

@interface SMStore (InternalMethods)

- (void) transactionCanceled: (SKPaymentTransaction *)transaction;
- (void) failedTransaction: (SKPaymentTransaction *)transaction;

- (void) provideContent: (NSString*) productIdentifier 
			 forReceipt: (NSData*) recieptData;
@end

@implementation SMStore

@synthesize delegate;



- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	NSLog(@"SMStore : paymentQueue ");
	
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				
                [self completeTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateFailed:
				
                [self failedTransaction:transaction];
				
                break;
				
            case SKPaymentTransactionStateRestored:
				
                [self restoreTransaction:transaction];
				
            default:
				
                break;
		}			
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
	NSLog(@"SMStore : restoreCompletedTransactionsFailedWithError %@ ",error);
	NSString *message = [NSString stringWithFormat:@"Error! %@ %@",
						 [error localizedDescription],
						 [error localizedFailureReason]];
	
	
	if(self.delegate != nil)
	{
		if(message != nil)
		{
			[self.delegate transactionFailedWithError:message];
		}
		
	}
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue 
{
	NSLog(@"SMStore : paymentQueueRestoreCompletedTransactionsFinished ");
	if(self.delegate != nil)
	{
		[self.delegate transactionFailedWithError:@"Failed"];
		
		
	}
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{	
	NSLog(@"SMStore : failedTransaction ");
	
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
	if(self.delegate != nil)
	{
		[self.delegate transactionFailedWithError:@"Failed"];
		
		
	}
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction
{		
	tranReceipt=transaction;
	NSLog(@"SMStore : completeTransaction ");
	//selvam4274@gmail.com
	NSString* newStr = [NSString stringWithUTF8String:[transaction.transactionReceipt bytes]];
	
	NSLog(@"SMStore Receipt completeTransaction: Method===>%@",newStr);
	//End
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
	
	if(self.delegate != nil)
	{
		[self.delegate transactionComplete:transaction.transactionReceipt];
				
	}
	
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{	
	NSLog(@"SMStore : restoreTransaction ");
   [[SKPaymentQueue defaultQueue] finishTransaction: transaction];	
}

@end
