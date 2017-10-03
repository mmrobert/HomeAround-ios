//
//  MsgBoxItemTableViewCell.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-13.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MsgBoxItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *timeMsg;
@property (weak, nonatomic) IBOutlet UILabel *lastMsg;

@end
