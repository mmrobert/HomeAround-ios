//
//  JobDeleteTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-08-03.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JobDeleteTableViewCell;

@protocol JobDeleteTableViewCellDelegate <NSObject>

//@optional

- (void)deleteTheJob:(JobDeleteTableViewCell *)cellView;

@end

@interface JobDeleteTableViewCell : UITableViewCell

@property (unsafe_unretained) NSObject<JobDeleteTableViewCellDelegate> *delegate;

- (IBAction)deleteJob:(id)sender;

@end
