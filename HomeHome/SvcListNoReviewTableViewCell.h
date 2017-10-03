//
//  SvcListNoReviewTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-26.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SvcListNoReviewTableViewCell;

@protocol SvcListNoReviewTableViewCellDelegate <NSObject>

//@optional

- (void)deleteSvcNoReview:(SvcListNoReviewTableViewCell *)cellView;

@end

@interface SvcListNoReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *deleteC;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (unsafe_unretained) NSObject<SvcListNoReviewTableViewCellDelegate> *delegate;

@end
