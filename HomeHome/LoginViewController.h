//
//  LoginViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIView *containerView1;

@property (weak, nonatomic) IBOutlet UIButton *loginOutlet;

- (IBAction)loginAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLogin;

- (IBAction)returnToLogin:(UIStoryboardSegue *)segue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end
