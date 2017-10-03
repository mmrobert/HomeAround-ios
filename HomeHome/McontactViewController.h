//
//  McontactViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-27.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface McontactViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;
- (IBAction)emailAct:(id)sender;

@end
