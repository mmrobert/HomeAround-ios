//
//  MsettingTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-27.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MphotoSetTableViewCell.h"

@interface MsettingTableViewController : UITableViewController <MphotoSetTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideBarItem;
- (IBAction)saveAct:(id)sender;

@end
