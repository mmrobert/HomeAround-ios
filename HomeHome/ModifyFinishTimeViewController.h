//
//  ModifyFinishTimeViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyFinishTimeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *timePicking;

@property int situationCode;

@property (strong, nonatomic) NSString *timeToFinishStr;

- (IBAction)doneTimePick:(id)sender;

@end
