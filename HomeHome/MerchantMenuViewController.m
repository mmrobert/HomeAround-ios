//
//  MerchantMenuViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-18.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "MerchantMenuViewController.h"
#import "SWRevealViewController.h"
#import "AppConstants.h"

@interface MerchantMenuViewController ()

@property (strong, nonatomic) NSArray *menuItems;

@end

@implementation MerchantMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  CGFloat imgW = self.photo.frame.size.width;
  //  self.photo.layer.cornerRadius = imgW / 2;
 //   self.photo.layer.borderWidth = 1;
 //   self.photo.layer.borderColor = [[UIColor grayColor] CGColor];
 //   self.photo.clipsToBounds = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.menuItems = @[@"JobPostedCell", @"MyJobCell", @"MsgBoxCell", @"RatingCell", @"ContactCell", @"SettingCell", @"LogoutCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSData *imgData = [[NSUserDefaults standardUserDefaults] objectForKey:myPhoto];
    if (imgData) {
        self.photo.image = [UIImage imageWithData:imgData];
    } else {
        self.photo.image = [UIImage imageNamed:@"User"];
    }
    NSString *nameStr = [[NSUserDefaults standardUserDefaults] objectForKey:myNickName];
    if (nameStr) {
        self.name.text = nameStr;
    } else {
        self.name.text = @"You";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //   return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //   return the number of rows
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    // Configure the cell...
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
