//
//  RoleChooseViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-31.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "RoleChooseViewController.h"
#import "RegisterViewController.h"

@interface RoleChooseViewController ()

@end

@implementation RoleChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   CGFloat imgW = self.customerContainer.frame.size.width;
    self.customerContainer.layer.cornerRadius = 10.0;
    self.customerContainer.clipsToBounds = YES;
    self.proContainer.layer.cornerRadius = 10.0;
    self.proContainer.clipsToBounds = YES;
    
    UITapGestureRecognizer *toSignUp1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signUp1:)];
    [self.customerContainer addGestureRecognizer:toSignUp1];
    self.customerContainer.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *toSignUp2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(signUp2:)];
    [self.proContainer addGestureRecognizer:toSignUp2];
    self.proContainer.userInteractionEnabled = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)signUp1:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signUpNavi"];
    UINavigationController *nv = (UINavigationController *)controller;
    RegisterViewController *rv = (RegisterViewController *)[nv topViewController];
    rv.roleStr = @"customer";
    [self presentViewController:nv animated:YES completion:nil];
}

- (void)signUp2:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signUpNavi"];
    UINavigationController *nv = (UINavigationController *)controller;
    RegisterViewController *rv = (RegisterViewController *)[nv topViewController];
    rv.roleStr = @"merchant";
    [self presentViewController:nv animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
