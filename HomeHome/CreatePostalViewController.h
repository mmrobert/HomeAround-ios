//
//  CreatePostalViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostalViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeTxt;
@property (weak, nonatomic) IBOutlet UILabel *descriptionL1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIButton *laterOutlet;
- (IBAction)saveAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView2;
@property (weak, nonatomic) IBOutlet UILabel *countryL;

@end
