//
//  ComposeReviewViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-06.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeReviewViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *rateValue;
@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property (strong, nonatomic) NSString *emailForReview;

- (IBAction)postIt:(id)sender;

@end
