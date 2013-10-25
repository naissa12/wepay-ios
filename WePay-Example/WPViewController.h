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

- (IBAction)submit:(id)sender;

@end
