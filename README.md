In-App-Purchase-ios
===================


1.Get your unique product id on iTunes connect.

2.Give your product id on SMSettings.h  #define productId @"yourProductId"

3.In which ViewController you want inapp purchase add this settings
  
  In .h file:
  ___________
  

    #import "SMpurchase.h"
  
    @interface yourPurchaseView : UIViewController <SMpurchaseDelegate> {
    }
   
  In .m file:
  ___________
  
   Action on Purchse Button:
  
     SMpurchase *smPurchase=[[SMpurchase alloc]init];
     smPurchase.delgate=self;
     [smPurchase purchaseProductPayment];


  Add delegate methods SMpurchaseDelegate:

    -(void)purchaseProductSucess{
      }
    -(void)purchaseProductFail{
       }

4.If you get successful Purchase then your Receipt save on NSUserdefault key="yourProductId"
  
  and -(void)purchaseProductSucess method invoke.

5.If your Purchase is Fail then -(void)purchaseProductFail method invoke.



Let me know any quires Skype : selvam4274
                       mail  : selvam4274@gmail.com
  
  
