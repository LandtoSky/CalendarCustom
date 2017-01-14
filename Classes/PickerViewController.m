//
//  PickerViewController.m
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/8/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "PickerViewController.h"
#import "UILabel+UIDatePickerLabels.h"
#import "UIViewController+PresentViewControllerOverCurrentContext.h"


typedef enum {
    // * Show year for only prev/next year, not for current year
    // * "dd MMM, hh:mm a" or "yyyy dd MMM, hh:mm a"
    DateFormatDateWithFlexibleYearAndTime = 1,
    // * "dd MMM yyyy"
    DateFormatDate,
    // * Time(if dates the same) or Date With Flexible Year
    // * "hh:mm a" or "dd MMM" or "yyyy dd MMM"
    DateFormatTimeOrDateWithFlexibleYear,
    //! Date format used to interact with server
    DateFormatForBackend,
    //! Date format used to interact with server with no time value
    DateFormatForBackendNoTime,
    //! Date With Flexible Year
    // * "dd MMM" or "yyyy dd MMM"
    DateFormatDateWithFlexibleYear,
    //! Time only
    // * "hh:mm a"
    DateFormatTime,
    //! Date only with slashes
    // * MM/dd/yyyy
    DateFormatFacebook
    
} DateFormat;


@interface PickerViewController () <UIScrollViewDelegate>
{
    // Land Custom
     IBOutletCollection(UIButton) NSMutableArray *tabBarBtns;
     IBOutlet UILabel *underLbl;
    
    // ScrollView
    IBOutlet UIScrollView *tabScrollView;
    IBOutletCollection(UIView) NSMutableArray *pageView;
    
    IBOutlet UIDatePicker *startsDatePicker, *endsDatePicker;
    IBOutlet UILabel *startsResLbl, *endsResLbl;
    
}
// * Save selected item with CustomPickerType to property
@property (nonatomic) NSUInteger indexOfSelectedRowInPicker;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end


@implementation PickerViewController 


#pragma mark - Getters/Setters

// Land Custom
- (void)initUI
{
    tabScrollView.delegate = self;
    
    /* Adjust Frame Layout */
    CGRect frame = CGRectZero;
    frame = tabScrollView.frame;
    for (int i = 0; i < 2; i++)
    {
        
        frame.origin.x = tabScrollView.frame.size.width * i;
        frame.origin.y = 0;
        [pageView[i] setFrame:frame];
        
    }
    
    [tabScrollView setContentSize:CGSizeMake(tabScrollView.frame.size.width*2, tabScrollView.frame.size.height)];
    [tabScrollView setPagingEnabled:YES];
    
    
    // DatePicker type set
    startsDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    startsDatePicker.minuteInterval = 1;
    startsDatePicker.date = [NSDate date];
    [startsDatePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    endsDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    endsDatePicker.minuteInterval = 1;
    endsDatePicker.date = [NSDate date];
    [endsDatePicker addTarget:self action:@selector(onDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Start & End Res Label
    [startsResLbl setText:[self.dateFormatter stringFromDate:[NSDate date]]];
    [endsResLbl setText:[self.dateFormatter stringFromDate:[NSDate date]]];
}

#pragma mark - onTabBar Button
- (IBAction)onTabBarButton:(UIButton*)sender
{
    NSInteger index = [tabBarBtns indexOfObject:sender];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [tabScrollView setContentOffset:CGPointMake(tabScrollView.frame.size.width * index, 0)];
                         
                     }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != tabScrollView) return;
    
    CGRect frame = underLbl.frame;
    frame.origin.x = scrollView.contentOffset.x / 2;
    underLbl.frame = frame;
    
    /* Get Current Page Number */
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    if (page == 0) {
        
        
    } else if (page == 1){
        
    }
    
    [scrollView setScrollEnabled:YES];
}



- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"MMM dd, yyyy hh:mm a"];

    }
    return _dateFormatter;
}

- (NSDateFormatter *)dateFormatterWithFormat:(DateFormat)dateFormat withPickedDate:(NSDate *)pickedDate
{
    switch (dateFormat)
    {
        case DateFormatDateWithFlexibleYearAndTime:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show year for only prev/next year, not for current year
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *pickedDateComponents = [calendar components:NSCalendarUnitYear fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedYear == currentYear && self.enableShortDates) {
                [self.dateFormatter setDateFormat:@"dd MMM, hh:mm a"];
            } else {
                [self.dateFormatter setDateFormat:@"yyyy dd MMM, hh:mm a"];
            }
        } break;
            
        case DateFormatTimeOrDateWithFlexibleYear:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show Hours and Minutes - if it of current day; if not - show Day and Month if it of current year; if not - show Year, Day, Month
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *pickedDateComponents = [calendar components:units fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:units fromDate:[NSDate date]];
            NSUInteger pickedDay = [pickedDateComponents day];
            NSUInteger currentDay = [currentDateComponents day];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedDay == currentDay) {
                [self.dateFormatter setDateFormat:@"hh:mm a"];
            } else
                if (pickedYear == currentYear)
                {
                    [self.dateFormatter setDateFormat:@"dd MMM"];
                } else {
                    [self.dateFormatter setDateFormat:@"yyyy, dd MMM"];
                }
        } break;
            
        case DateFormatDateWithFlexibleYear:
        {
            if (!pickedDate) {
                NSLog(@"Error: dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime required pickedDate");
                return self.dateFormatter;
            }
            
            // * Show Day and Month if it of current year; if not - show Year, Day, Month
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSCalendarUnit units = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *pickedDateComponents = [calendar components:units fromDate:pickedDate];
            NSDateComponents *currentDateComponents = [calendar components:units fromDate:[NSDate date]];
            NSUInteger pickedYear = [pickedDateComponents year];
            NSUInteger currentYear = [currentDateComponents year];
            if (pickedYear == currentYear && self.enableShortDates)
            {
                [self.dateFormatter setDateFormat:@"dd MMM"];
            } else {
                [self.dateFormatter setDateFormat:@"yyyy, dd MMM"];
            }
        } break;
            
        case DateFormatTime:
        {
            [self.dateFormatter setDateFormat:@"hh:mm a"];
        } break;
            
        case DateFormatDate:
        {
            [self.dateFormatter setDateFormat:@"dd MMM yyyy"];
        } break;
            
        case DateFormatForBackend:
        {
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        } break;
            
        case DateFormatForBackendNoTime:
        {
            [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
        } break;
            
        case DateFormatFacebook:
        {
            [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
        } break;
            
        default:
            break;
    }
    
    return self.dateFormatter;
}


#pragma mark - LifeCycle


- (instancetype)initFromNib
{
    return [self initWithNibName:@"PickerViewController" bundle:nil];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.view.backgroundColor = [UIColor clearColor];
    
    self.enableShortDates = YES;
    
    // Land
    [self initUI];
}


#pragma mark - Getters/Setters


- (void)setPickerType:(PickerType)pickerType
{
    
            self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
//            self.datePicker.minimumDate = [NSDate date];
            // Land Set Minute Interval
            self.datePicker.minuteInterval = 1;
            self.datePicker.date = [NSDate date];
}

- (void)setInitialDate:(NSDate *)date
{
    if (date) {
        self.datePicker.date = date;
    }
}

- (void)setMinimalDate:(NSDate *)date
{
    if (date) {
        self.datePicker.minimumDate = date;
    }
}


#pragma mark - Events

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    
    NSLog(@"Res Date == %@",[self.dateFormatter stringFromDate:datePicker.date]);
    if (datePicker == startsDatePicker) {
        [startsResLbl setText:[self.dateFormatter stringFromDate:datePicker.date]];

    } else if (datePicker == endsDatePicker) {
        [endsResLbl setText:[self.dateFormatter stringFromDate:datePicker.date]];
    }
}

- (IBAction)onStartsResLblDel:(id)sender
{
    [startsResLbl setText:@""];
}

- (IBAction)onEndsResLblDel:(id)sender
{
    [endsResLbl setText:@""];
}

- (IBAction)dismissButtonAction:(UIButton *)sender
{
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}

- (IBAction)cancelButtonAction:(UIButton *)sender
{
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}

- (IBAction)doneButtonAction:(UIButton *)sender
{

     // * Format date
//    NSDateFormatter *dateFormatter;
//    if (self.pickerType == DateAndTimePickerType)
//    {
//        dateFormatter = [self dateFormatterWithFormat:DateFormatDateWithFlexibleYearAndTime withPickedDate:self.datePicker.date];
//    }
//    
//    [self.delegate didSelectDate:self.datePicker.date formattedString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self.datePicker.date]]];

    [self.delegate didSelectStartsDate:startsResLbl.text endsDateStr:endsResLbl.text];

    
    [self dismissViewControllerOverCurrentContextAnimated:YES completion:nil];
}


@end
