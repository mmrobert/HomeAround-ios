//
//  MerchantMenuViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-18.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *userContainer;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
