//
//  MJobStatusTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJobStatusTableViewCell;

@protocol MJobStatusTableViewCellDelegate <NSObject>

//@optional

- (void)changeTheStatus:(MJobStatusTableViewCell *)cellView;

@end

@interface MJobStatusTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusL;
@property (weak, nonatomic) IBOutlet UILabel *changeStatusL;
@property (weak, nonatomic) IBOutlet UIView *changeContainer;

@property (unsafe_unretained) NSObject<MJobStatusTableViewCellDelegate> *delegate;

@end
