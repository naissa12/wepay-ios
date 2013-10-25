//
//  WPViewController.h
//  WePay-Example
//
//  Created by WePay on 10/24/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *creditCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *expirationMonth;
@property (weak, nonatomic) IBOutlet UITextField *expirationYear;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (weak, nonatomic) IBOutlet UITextField *zipcode;

/*
 Send token creditCardId to server.
 */
- (void) sendToken: (NSString *) creditCardId;

/*
  Submits payment form to WePay.
 */
- (IBAction)submit:(id)sender;

@end
