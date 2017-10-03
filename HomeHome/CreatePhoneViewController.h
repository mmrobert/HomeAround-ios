//
//  CreatePhoneViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-31.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePhoneViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UITextField *textEnter;
@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
- (IBAction)saveAct:(id)sender;

@end
