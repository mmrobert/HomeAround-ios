//
//  CreateBioDetailViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-31.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateBioDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textEnter;
@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
- (IBAction)saveAct:(id)sender;
- (IBAction)laterAct:(id)sender;

@end
