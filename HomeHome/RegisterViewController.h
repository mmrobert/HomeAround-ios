//
//  RegisterViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-21.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImg;
@property (weak, nonatomic) IBOutlet UIImageView *pwConfirmImg;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UITextField *pwConfirmTxt;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UIButton *registerOutlet;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRegisterBtn;

@property (strong, nonatomic) NSString *roleStr;

- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIView *containerView2;

@end
