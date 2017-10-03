//
//  AuthViewController.h
//  HomeHome
//
//  Created by boqian cheng on 2016-06-20.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthViewController : UIViewController

- (IBAction)returnToAuth:(UIStoryboardSegue *) segue;
@property (weak, nonatomic) IBOutlet UILabel *errorMsgDisplay;

@end

