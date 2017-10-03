//
//  ServiceReviewTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-05.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceReviewTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (weak, nonatomic) IBOutlet UILabel *reviewTime;
@property (weak, nonatomic) IBOutlet UILabel *reviewER;
@property (weak, nonatomic) IBOutlet UILabel *reviewContent;

@end
