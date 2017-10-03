//
//  MJobDeleteTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-22.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJobDeleteTableViewCell;

@protocol MJobDeleteTableViewCellDelegate <NSObject>

//@optional

- (void)deleteTheJob:(MJobDeleteTableViewCell *)cellView;

@end

@interface MJobDeleteTableViewCell : UITableViewCell

- (IBAction)deleteAct:(id)sender;

@property (unsafe_unretained) NSObject<MJobDeleteTableViewCellDelegate> *delegate;

@end
