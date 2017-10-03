//
//  CreateNameViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNameViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView1;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIButton *laterOutlet;
- (IBAction)saveAct:(id)sender;

@end
