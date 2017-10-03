//
//  NamePostPhoneViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-28.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NamePostPhoneViewController : UIViewController <UITextFieldDelegate>

@property int situationCode;
@property (weak, nonatomic) IBOutlet UITextField *textEnter;
- (IBAction)saveAct:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)cancelAct:(id)sender;

@end
