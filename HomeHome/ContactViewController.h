//
//  ContactViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-15.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ContactViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;
- (IBAction)emailUs:(id)sender;

@end
