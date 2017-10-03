//
//  AuthViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-06-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "AuthViewController.h"
#import "AppConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.errorMsgDisplay.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.errorMsgDisplay.text = @"";
/*
    NSString *email = @"aa@bb.ca";
    [[NSUserDefaults standardUserDefaults] setObject:email forKey:myEmail];
    NSString *password = @"12345";
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:myPassword];
    NSString *role = @"customer";
    [[NSUserDefaults standardUserDefaults] setObject:role forKey:myRole];
    [[NSUserDefaults standardUserDefaults] synchronize];
*/
    NSString *uEmail = [[NSUserDefaults standardUserDefaults] objectForKey:myEmail];
    NSString *uPassword = [[NSUserDefaults standardUserDefaults] objectForKey:myPassword];
    
  //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:myCountry];
    
    // NSLog(@"8888yyy: %@", userID);
    
    if (uEmail && uPassword) {
        [self connectingServer];
      //  [self toMainPages];
    } else {
        UIViewController *authController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LogInNavigatorSB"];
        [self presentViewController:authController animated:YES completion:nil];
    }
}

#pragma networking

- (void)connectingServer {
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.label.text = @"Connecting server...";
    
    NSError *err;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Server, @"updatedeviceinfo"]];
    NSString *uToken = [[NSUserDefaults standardUserDefaults] objectForKey:myToken];
    
    BOOL allowRemote = [[NSUserDefaults standardUserDefaults] boolForKey:myRemoteNoteAllow];
    NSString *dToken;
    if (allowRemote) {
        dToken = [[NSUserDefaults standardUserDefaults] objectForKey:myDeviceToken];
    } else {
        dToken = @"0";
    }
    
    NSDictionary *myData = [[NSDictionary alloc] initWithObjectsAndKeys:uToken, @"token", @"ios", @"platform", dToken, @"devicetoken", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:myData options:0 error:&err];
    [AppDelegate netWorkJob:url httpMethod:@"POST" withAuth:nil withData:postData withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            } else {
                BOOL success = [[returnedDict objectForKey:@"success"] boolValue];
                //  NSInteger code = [[returnedDict objectForKey:@"responseCode"] integerValue];
                //  NSString *aa = (success) ? @"true" : @"false";
                NSString *msg = [returnedDict objectForKey:@"message"];
                //   NSLog(@"pp-pp-pp--%@--%lu", msg, (unsigned long)code);
                if (success) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self toMainPages];
                } else {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                //    NSString *alertMsg = msg;
                //    NSString *okTitle = @"OK";
                //    [self presentaAlert:nil withMsg:alertMsg withConfirmTitle:okTitle];
                    self.errorMsgDisplay.text = @"Something wrong, please re-start app!";
                }
                
            }
        }
    }];
}

- (void)toMainPages {
    NSString *uRole = [[NSUserDefaults standardUserDefaults] objectForKey:myRole];
    
    //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:myCountry];
    // NSLog(@"8888yyy: %@", userID);
    
    if ([uRole isEqualToString:@"customer"]) {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Custom" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseCustom"];
        [self presentViewController:mainController animated:YES completion:nil];
        //   if ([[self appDelegate] connect]) {
        //   NSLog(@"show buddy list");
        //   }
        
    } else {
        UIViewController *mainController = [[UIStoryboard storyboardWithName:@"Merchant" bundle:nil] instantiateViewControllerWithIdentifier:@"MainSlidingBaseMerchant"];
        [self presentViewController:mainController animated:YES completion:nil];
    }
}

#pragma alert presentation

- (void)presentaAlert:(NSString *)aTitle withMsg:(NSString *)aMsg withConfirmTitle:(NSString *)aConfirmTitle {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:aTitle
                                message:aMsg
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:aConfirmTitle
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)returnToAuth:(UIStoryboardSegue *) segue {
    
}

@end
