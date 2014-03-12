//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Eddie Tuggle on 11/19/12.
//  Copyright (c) 2012 etbits.com. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsEnteringANumber;
@property (nonatomic) BOOL userEnteredADecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;

@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsEnteringANumber = _userIsEnteringANumber;
@synthesize brain = _brain;
@synthesize userEnteredADecimalPoint = _userEnteredADecimalPoint;
@synthesize calculationCompleteIndicator = _calculationCompleteIndicator;

-(CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    
    NSString *digit = sender.currentTitle;
    if ([digit isEqualToString:@"."]) {
        if (!self.userEnteredADecimalPoint) {
            self.userEnteredADecimalPoint = YES;
            // Are we currently entering a number?
            if (!self.userIsEnteringANumber) {
                // the user enter a "." as the first value of the number.
                // make sure the leading zero is displayed
                self.display.text = @"0";
                self.userIsEnteringANumber = YES;
            }
        } else {
            // Already entered... ignore this one.
            return;
        }
    } else if ([digit isEqualToString:@"0"]) {
        // Avoid a bunch of meaningless zeros
        if (!self.userIsEnteringANumber) {
            self.display.text = @"0";
            // Just ignore this zero
            return;
        }
    }
    if (self.userIsEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsEnteringANumber = YES;
    }    
    self.calculationCompleteIndicator.hidden = YES;
    
    NSLog(@"digit pressed = %@", digit);
}
- (IBAction)backspacePressed:(UIButton *)sender {
        if (self.userIsEnteringANumber)
        {
            int lengthOfDisplay = [self.display.text length];
            self.display.text = [self.display.text substringToIndex:(lengthOfDisplay-1)];
        }
    if (self.display.text.length ==0) {
        self.display.text = @"0";
        self.userIsEnteringANumber = NO;
    }
}
- (IBAction)clearPressed:(UIButton *)sender {
    // Clear the calculator
    
    // Remove the indicator that says a calculation is displayed
    self.calculationCompleteIndicator.hidden = YES;
    
    // Clear the history and set the display to 0
    self.historyDisplay.text = @"";
    self.display.text = @"0";
    
    // Tell the brain to clean up
    [self.brain clear];
}
- (IBAction)changeSignPressed:(UIButton *)sender {
    // Change the sign of the number in the display
    // changing the sign will not cause a push to the stack, but simply
    // change the sign of the value displayed in the display.
    // check to see if we have a 0 or 0.0 displayed
    double val = [self.display.text doubleValue];
    if (val!=0.0) {
        if ([self.display.text hasPrefix:@"-"]) {
            // looks like the number is already negative.  Make it positive.
            self.display.text = [self.display.text substringFromIndex:1];
        } else {
            // it looks like a positive number.  Make it negative.
            self.display.text = [NSString  stringWithFormat:@"-%@",self.display.text];
        }
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsEnteringANumber) {
        [self enterPressed];
    }
    [self addToHistory:sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    self.calculationCompleteIndicator.hidden = NO;

}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self addToHistory:self.display.text];

    self.userIsEnteringANumber = NO;
    self.userEnteredADecimalPoint = NO;
}

- (IBAction)piPressed {
    // Display the value of pi.
    [self displayValueOnCalculator:[NSString stringWithFormat:@"%1.7g", M_PI]];
    
    // Not the result of a calculation.
    self.calculationCompleteIndicator.hidden = YES;
}
- (IBAction)ePressed {
    // Display the value of e.
    [self displayValueOnCalculator:[NSString stringWithFormat:@"%1.7g", M_E]];
    
    // Not the result of a calculation.
    self.calculationCompleteIndicator.hidden = YES;

}

- (void) displayValueOnCalculator:(NSString *) valueToDisplay {
    if (self.userIsEnteringANumber) {
        [self enterPressed];
    }
    self.display.text = valueToDisplay;
    [self enterPressed];
    self.userIsEnteringANumber = NO;
}

- (void) addToHistory:(NSString *)valueToDisplay
{
   
    if ([valueToDisplay isEqualToString:[NSString stringWithFormat:@"%1.7g",M_PI]]) {
        valueToDisplay = @" π";
    } else if([valueToDisplay isEqualToString:[NSString stringWithFormat:@"%1.7g",M_E]]) {
        valueToDisplay = @" e";
    }
    
    valueToDisplay = [valueToDisplay stringByAppendingString:@" "];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingString:valueToDisplay];
}
@end
