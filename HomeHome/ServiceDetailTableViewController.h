//
//  ServiceDetailTableViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-07-05.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ServiceDescriptionTableViewCell.h"
#import "NoReviewDesTableViewCell.h"

@interface ServiceDetailTableViewController : UITableViewController <ServiceDescriptionTableViewCellDelegate, NoReviewDesTableViewCellDelegate>

@property (readonly, strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property int situationCode;

@property (strong, nonatomic) NSDictionary *serviceFindDict;
@property (strong, nonatomic) NSString *serviceCatStr;

- (IBAction)cancelAct:(id)sender;

@end
