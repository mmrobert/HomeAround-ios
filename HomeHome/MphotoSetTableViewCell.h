//
//  MphotoSetTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-28.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MphotoSetTableViewCell;

@protocol MphotoSetTableViewCellDelegate <NSObject>

//@optional

- (void)updatePhoto:(MphotoSetTableViewCell *)cellView;

@end

@interface MphotoSetTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (unsafe_unretained) NSObject<MphotoSetTableViewCellDelegate> *delegate;

@end
