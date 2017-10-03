//
//  MBioDetailViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-30.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBioDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textEnter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
- (IBAction)cancelAct:(id)sender;
- (IBAction)doneAct:(id)sender;

@end
