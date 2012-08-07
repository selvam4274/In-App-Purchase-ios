
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef NDEBUG
#define kReceiptValidationURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#else
#define kReceiptValidationURL @"https://buy.itunes.apple.com/verifyReceipt"
#endif
/*Do't change Used to Verfy Receipt Apple*/
#define kSharedSecret @"1e6f689d37094d62967f7971ed3d39f1"


/*productId Get from your iTunes Connect*/
#define productId @"UinqueProductId"

