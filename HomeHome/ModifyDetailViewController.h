//
//  ModifyDetailViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-03.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyDetailViewController : UIViewController

@property (strong, nonatomic) NSString *detailStr;
@property int situationCode;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

- (IBAction)doneDetail:(id)sender;

@end
