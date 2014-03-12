//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Eddie Tuggle on 11/19/12.
//  Copyright (c) 2012 etbits.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (double)performOperation:(NSString *) operation;
- (void)clear;

@property (readonly) id program;
+ (double) runProgram:(id)program;
+ (NSString *) descriptionOfProgram:(id)program;
@end
