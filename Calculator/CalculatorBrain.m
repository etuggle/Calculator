//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Eddie Tuggle on 11/19/12.
//  Copyright (c) 2012 etbits.com. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
- (NSMutableArray *)programStack
{
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)setProgramStack:(NSMutableArray *)programStack
{
    _programStack = programStack;
}

- (void) pushOperand:(double)operand
{
    NSLog(@"Pushing = %f", operand);

    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *) descriptionOfProgram:(id)program
{
    return @"Implement this in Assignment 2";
}

+ (double) popOperandOffStack:(NSMutableArray *) stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:([NSNumber class])])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:([NSString class])]){
        
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double num1 = [self popOperandOffStack:stack];
            double num2 = [self popOperandOffStack:stack];
            
            result = num2 - num1;
        } else if ([operation isEqualToString:@"/"]) {
            double denominator = [self popOperandOffStack:stack];
            double numerator = [self popOperandOffStack:stack];
            
            result = numerator / denominator;
        }else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack] * -1;
        }else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        }else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack]);
        }else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack]);
        }else if ([operation isEqualToString:@"log"]) {
            result = log([self popOperandOffStack:stack]);
        }else if ([operation isEqualToString:@"√"]) {
            result = sqrtl([self popOperandOffStack:stack]);
        }
    }
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]])
    {
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

//-(double) popOperand {
//    NSNumber *operandObject = self.operandStack.lastObject;
//    
//    if (operandObject) [self.operandStack removeLastObject];
//    NSLog(@"returning = %@", operandObject);
//    return operandObject.doubleValue;
//}

-(void) clearStack
{
    NSLog(@"Clear stack.");

    [self.programStack removeAllObjects];
    NSLog(@"Number of items in stack: %d", [self.programStack count]);

}
-(void)clear
{
    NSLog(@"Clear");
    // Clear the stack
    [self clearStack];
}

- (double)performOperation:(NSString *) operation
{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

@end
