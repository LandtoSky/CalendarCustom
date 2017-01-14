//
//  PickerViewController.h
//  IgorBizi@mail.ru
//
//  Created by IgorBizi@mail.ru on 5/8/15.
//  Copyright (c) 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+PresentViewControllerOverCurrentContext.h"


typedef enum {
    DateAndTimePickerType = 1, // * Event Date and Time
    DatePickerType, // * Birthday Date
    CustomPickerType // * Custom picker of any items
} PickerType;


@protocol PickerViewControllerDelegate <NSObject>
@optional
- (void)didSelectStartsDate:(NSString *)startsDate endsDateStr:(NSString*) endsDate;
@end


// * ViewController with picker/datePicker
@interface PickerViewController : UIViewController
//! Designated initializer
- (instancetype)initFromNib;

@property (nonatomic, weak) id <PickerViewControllerDelegate> delegate;


//** For Customization

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

//! Enable short format for picked 'date String'. YES as default
@property (nonatomic) BOOL enableShortDates;

// * For CustomPickerType only
@property (nonatomic, strong) NSArray *dataSourceForCustomPickerType; // of NSString, of NSNumber

// * Set predefined date
- (void)setInitialDate:(NSDate *)date;

//! Minimum date for date picker
- (void)setMinimalDate:(NSDate*)date;


// Land Custom


@end
