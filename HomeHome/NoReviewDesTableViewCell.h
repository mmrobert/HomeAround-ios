//
//  NoReviewDesTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-25.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoReviewDesTableViewCell;

@protocol NoReviewDesTableViewCellDelegate <NSObject>

//@optional

- (void)likeTheServiceNoReview:(NoReviewDesTableViewCell *)cellView;

@end

@interface NoReviewDesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *heart;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (unsafe_unretained) NSObject<NoReviewDesTableViewCellDelegate> *delegate;

@end
