//
//  CreateExpertiseViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-31.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateExpertiseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *laterBtn;
- (IBAction)saveAct:(id)sender;

@end
