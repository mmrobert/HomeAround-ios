//
//  ForgotPasswordViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *askWordL;
@property (weak, nonatomic) IBOutlet UIImageView *emailImg;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIButton *resetOutlet;
@property (weak, nonatomic) IBOutlet UIView *containerView1;
- (IBAction)resetAction:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topReset;

@end
