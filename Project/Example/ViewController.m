//
//  ViewController.m
//  Example
//
//  Created by IgorBizi@mail.ru on 12/16/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "ViewController.h"
#import "PickerViewController.h"


@interface ViewController ()<PickerViewControllerDelegate>
@end


@implementation ViewController




- (IBAction)dateAndTimeButtonAction:(id)sender
{
    PickerViewController *pickerViewController = [[PickerViewController alloc] initFromNib];
    pickerViewController.delegate = self;

//    [pickerViewController setInitialDate:[NSDate date]];
//    [pickerViewController setminimalDate:[NSDate date]];
    [self presentViewControllerOverCurrentContext:pickerViewController animated:YES completion:nil];
}

- (void)didSelectStartsDate:(NSString *)startsDate endsDateStr:(NSString *)endsDate{
    NSLog(@"Start Date = %@",startsDate);
    NSLog(@"Ends date = %@", endsDate);
}


@end
