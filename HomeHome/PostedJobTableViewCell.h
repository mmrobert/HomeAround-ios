//
//  PostedJobTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-19.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostedJobTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UILabel *timeFinish;

@end
