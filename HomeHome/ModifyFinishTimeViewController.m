//
//  ModifyFinishTimeViewController.m
//  HomeHome
//
//  Created by boqian cheng on 2016-07-02.
//  Copyright © 2016 Boqian Cheng. All rights reserved.
//

#import "ModifyFinishTimeViewController.h"
#import "NSString+EmptyCheck.h"

@interface ModifyFinishTimeViewController ()

@end

@implementation ModifyFinishTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.timeToFinishStr isStringEmpty] || self.timeToFinishStr == nil) {
        NSDate *now = [NSDate date];
        [self.timePicking setDate:now];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSDate *date = [formatter dateFromString:self.timeToFinishStr];
        [self.timePicking setDate:date];
    }
    [self.timePicking addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)datePickerChanged:(UIDatePicker *)picker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    
    NSString *dateStr = [formatter stringFromDate:picker.date];
    self.timeToFinishStr = dateStr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doneTimePick:(id)sender {
    if (self.situationCode == 0) {
        NSString *key = @"keyStr";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.timeToFinishStr forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFinishTimeC" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.situationCode == 1) {
        NSString *key = @"keyStr";
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.timeToFinishStr forKey:key];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificationFinishTimeModify" object:nil userInfo:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
