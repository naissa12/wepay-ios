//
//  WPViewController.m
//  WePay-Example
//
//  Created by WePay on 10/24/13.
//  Copyright (c) 2013 WePay. All rights reserved.
//

#import "WPCreditCard.h"
#import "WPViewController.h"

@interface WPViewController ()
{
    UIActivityIndicatorView * activityView;
}

@end

@implementation WPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView.backgroundColor = [UIColor clearColor];
    
    self.name.leftView = leftView;
    self.name.leftViewMode = UITextFieldViewModeAlways;
    self.name.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView1 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView1.backgroundColor = [UIColor clearColor];
    
    self.email.leftView = leftView1;
    self.email.leftViewMode = UITextFieldViewModeAlways;
    self.email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView2 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView2.backgroundColor = [UIColor clearColor];
    
    self.securityCode.leftView = leftView2;
    self.securityCode.leftViewMode = UITextFieldViewModeAlways;
    self.securityCode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView3 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView3.backgroundColor = [UIColor clearColor];
    
    self.creditCardNumber.leftView = leftView3;
    self.creditCardNumber.leftViewMode = UITextFieldViewModeAlways;
    self.creditCardNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView4 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView4.backgroundColor = [UIColor clearColor];
    
    self.zipcode.leftView = leftView4;
    self.zipcode.leftViewMode = UITextFieldViewModeAlways;
    self.zipcode.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView5 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView5.backgroundColor = [UIColor clearColor];
    
    self.expirationMonth.leftView = leftView5;
    self.expirationMonth.leftViewMode = UITextFieldViewModeAlways;
    self.expirationMonth.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UILabel * leftView6 = [[UILabel alloc] initWithFrame:CGRectMake(10,0,7,26)];
    leftView6.backgroundColor = [UIColor clearColor];
    
    self.expirationYear.leftView = leftView6;
    self.expirationYear.leftViewMode = UITextFieldViewModeAlways;
    self.expirationYear.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) sendToken: (NSString *) creditCardId
{
    // Change the callUrl to the server url where you want the token sent
    NSURL * callUrl = [NSURL URLWithString: @"https://stage.wepay.com"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL: callUrl];
    
    [request setHTTPMethod: @"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"charset" forHTTPHeaderField:@"utf-8"];
    
    NSString *body     = [NSString stringWithFormat:@"creditCardId=%@", creditCardId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue: queue
                           completionHandler:^(NSURLResponse *response, NSData  *data, NSError * requestError)
     {
         
         [activityView removeFromSuperview];
         
         if(requestError)
         {
             // Handle error
         }
         else
         {
             // Handle success
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Thanks for your payment." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
         }
     }];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag == 3)
    {// Restrict length for credit card number
        
        if (range.location == 19) {
            return NO;
        }
        
        if ([string length] == 0)
        {
            return YES;
        }
        
        if ((range.location == 4) || (range.location == 9) || (range.location == 14))
        {
            NSString *str  = [NSString stringWithFormat:@"%@ ",textField.text];
            textField.text = str;
        }
    }
    else if(textField.tag == 4)
    {// restrict length of expiration month field
    
        if (range.location == 2) {
            return NO;
        }
    }
    else if(textField.tag == 5)
    {// restrict length for expiration year field
        
        if (range.location == 2) {
            return NO;
        }
    }
    else if(textField.tag == 6)
    {// restrict length for security code field

        if (range.location == 4) {
            return NO;
        }
    }
    else if(textField.tag == 7)
    {// restrict length for zipcode field

        if (range.location == 5) {
            return NO;
        }
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)submit:(id)sender {
    
    WPUserDescriptor * userDescriptor = [[WPUserDescriptor alloc] init];
    userDescriptor.name = self.name.text;
    userDescriptor.email = self.email.text;
    userDescriptor.address = [[WPAddressDescriptor alloc] initWithZip: self.zipcode.text];
    
    WPCreditCardDescriptor * cardDescriptor = [[WPCreditCardDescriptor alloc] init];
    cardDescriptor.number = self.creditCardNumber.text;
    cardDescriptor.expirationMonth = [self.expirationMonth.text intValue];
    cardDescriptor.expirationYear = [self.expirationYear.text intValue];
    cardDescriptor.securityCode = self.securityCode.text;
    cardDescriptor.user = userDescriptor;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    // Send the user's card details to WePay and receive token
    [WPCreditCard createCardWithDescriptor: cardDescriptor success: ^(WPCreditCard * tokenizedCard) {
        
        // Card token from WePay
        NSLog(@"Token created with credit_card_id: %@", tokenizedCard.creditCardId);
        
        // Send token to your servers
        [self sendToken: tokenizedCard.creditCardId];
        
    } failure:^(NSError * error) {
        
        [activityView removeFromSuperview];
        
        /*
         Handle errors here.
         */

        NSLog(@"Error trying to create token %@", [error localizedDescription]);
        
        // Show an alert view with error description
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message: [error localizedDescription] delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil];
        [alert show];
        
    }];
}

@end
