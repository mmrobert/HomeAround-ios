//
//  JobStatusTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-01.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobStatusTableViewCell;

@protocol JobStatusTableViewCellDelegate <NSObject>

//@optional

- (void)changeJobStatus:(JobStatusTableViewCell *)cellView;

@end

@interface JobStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *changeStatusL;
@property (weak, nonatomic) IBOutlet UIView *changeContainer;

@property (unsafe_unretained) NSObject<JobStatusTableViewCellDelegate> *delegate;

@end
