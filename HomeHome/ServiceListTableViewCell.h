//
//  ServiceListTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-04.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceListTableViewCell;

@protocol ServiceListTableViewCellDelegate <NSObject>

//@optional

- (void)deleteService:(ServiceListTableViewCell *)cellView;

@end

@interface ServiceListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *serviceDetail;
@property (weak, nonatomic) IBOutlet UILabel *serviceRating;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;

@property (weak, nonatomic) IBOutlet UIImageView *deleteC;

@property (unsafe_unretained) NSObject<ServiceListTableViewCellDelegate> *delegate;

@end
