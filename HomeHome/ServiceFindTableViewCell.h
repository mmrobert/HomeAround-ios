//
//  ServiceFindTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-07.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceFindTableViewCell;

@protocol ServiceFindTableViewCellDelegate <NSObject>

//@optional

- (void)likeService:(ServiceFindTableViewCell *)cellView;

@end

@interface ServiceFindTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *detail;

@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (weak, nonatomic) IBOutlet UIImageView *heart;

@property (unsafe_unretained) NSObject<ServiceFindTableViewCellDelegate> *delegate;

@end
