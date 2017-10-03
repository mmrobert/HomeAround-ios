//
//  SvcFindNoReviewTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-25.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SvcFindNoReviewTableViewCell;

@protocol SvcFindNoReviewTableViewCellDelegate <NSObject>

//@optional

- (void)likeServiceNoReview:(SvcFindNoReviewTableViewCell *)cellView;

@end

@interface SvcFindNoReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIImageView *heart;

@property (unsafe_unretained) NSObject<SvcFindNoReviewTableViewCellDelegate> *delegate;

@end
