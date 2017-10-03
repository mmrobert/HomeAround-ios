//
//  MJobInfoTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJobInfoTableViewCell;

@protocol MJobInfoTableViewCellDelegate <NSObject>

//@optional

- (void)likeTheJob:(MJobInfoTableViewCell *)cellView;

@end

@interface MJobInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *heart;

@property (weak, nonatomic) IBOutlet UILabel *timePostedL;

@property (unsafe_unretained) NSObject<MJobInfoTableViewCellDelegate> *delegate;

@end
