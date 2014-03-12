//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Eddie Tuggle on 11/19/12.
//  Copyright (c) 2012 etbits.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *historyDisplay;
@property (weak, nonatomic) IBOutlet UILabel *calculationCompleteIndicator;

@end
