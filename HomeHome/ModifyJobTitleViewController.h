//
//  ModifyJobTitleViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-08-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyJobTitleViewController : UIViewController

@property (strong, nonatomic) NSString *titleStr;
@property int situationCode;

@property (weak, nonatomic) IBOutlet UITextView *textEnter;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
- (IBAction)saveAct:(id)sender;

@end
