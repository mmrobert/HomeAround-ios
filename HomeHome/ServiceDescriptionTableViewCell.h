//
//  ServiceDescriptionTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-05.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ServiceDescriptionTableViewCell;

@protocol ServiceDescriptionTableViewCellDelegate <NSObject>

//@optional

- (void)likeTheService:(ServiceDescriptionTableViewCell *)cellView;

@end

@interface ServiceDescriptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceName;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *reviewSum;
@property (weak, nonatomic) IBOutlet UILabel *serviceDes;

@property (weak, nonatomic) IBOutlet UIButton *sendMsgBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ratingStar;

@property (unsafe_unretained) NSObject<ServiceDescriptionTableViewCellDelegate> *delegate;

@end
