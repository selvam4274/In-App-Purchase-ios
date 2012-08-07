
#import "SMpurchase.h"
#import "NSData+Base64.h"
#import "JSON.h"


@implementation SMpurchase

@synthesize receipt;
@synthesize delegate;

@synthesize newStringCon;



-(void)purchaseProductPayment
{
	sMStore=[[SMStore alloc]init];
	sMStore.delegate = self;
	[[SKPaymentQueue defaultQueue] addTransactionObserver:sMStore]; 
	SKPayment *payment=[SKPayment paymentWithProductIdentifier:productId];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
	
}

-(void)transactionComplete:(NSData *)message
{
	receipt  = message;
	newStringCon = [NSString stringWithUTF8String:[receipt bytes]];
	[self verifyDirectApple];
}
-(void)transactionFailedWithError:(NSString *)message
{
    NSLog(@"SMpurchase : transactionFailedWithError:%@",message);
	
}


-(void)verifyDirectApple
{
	
	NSLog(@"SMpurchase : Verify Apple Called");
	
	dataFromConnection=[[NSMutableData alloc]init];
	NSURL *url = [NSURL URLWithString:kReceiptValidationURL];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
	
	[theRequest setHTTPMethod:@"POST"];		
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
    NSString *receiptString = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\" \"password\":\"%@\"}", [self.receipt base64EncodedString], kSharedSecret];        
    
	NSString *length = [NSString stringWithFormat:@"%d", [receiptString length]];
	
	[theRequest setValue:length forHTTPHeaderField:@"Content-Length"];	
	
	[theRequest setHTTPBody:[receiptString dataUsingEncoding:NSUTF8StringEncoding]];
	
	sConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self]; 
	
	[sConnection start];	
	
}





#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{	
	NSLog(@"SMpurchase : addReceiptOnComplete");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	NSLog(@"SMpurchase : didReceiveData");
	[dataFromConnection appendData:data];
	NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSLog(@"SMpurchase : didReceiveData %@",newStr);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    NSString *responseString = [[[NSString alloc] initWithData:dataFromConnection encoding:NSASCIIStringEncoding] autorelease];
	
	if(ServiceCheck == EVerifyApple )
	{
		NSLog(@"SMpurchase Verify Apple Finished %@",responseString);
		[self addReceiptOnComplete];
	}
	if(ServiceCheck == EAddReceipt)
	{
		NSLog(@" SMpurchase Verify EAddReceipt %@",responseString);
		NSDictionary *propertyList = [responseString JSONValue];
		
		int receiptsValue = [[propertyList  objectForKey:@"status"] intValue];
		
		NSLog(@"SMpurchase Receipts Status  %d",receiptsValue);
		
		
		if(receiptsValue  == 0)
		{
			NSLog(@"SMpurchase Receipts Status Successfull Receipts ");
            // Save Successfull Receipt Receipt defaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[self.receipt base64EncodedString] forKey:productId];
            [defaults synchronize];
            // end    

			
		}
        else{
            NSLog(@"SMpurchase Receipts Status Fail on Apple Verification ");
        }
		
	}
}


- (void)connection:(NSURLConnection *)connection  didFailWithError:(NSError *)error
{
	
	if(self.delegate != nil)
	{
		[self.delegate purchaseProductFail];
		
	}
	
}

- (void) transactionCanceled: (SKPaymentTransaction *)transaction
{
	
	if(self.delegate != nil)
	{
		[self.delegate purchaseProductFail];
		
	}
	
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if(self.delegate != nil)
	{
		[self.delegate purchaseProductFail];
		
	}
	
}


@end
