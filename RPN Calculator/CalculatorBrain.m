//
//  CalculatorBrain.m
//  RPN Calculator
//
//  Created by Simon Silverleaf on 8/24/12.
//  Copyright (c) 2012 Simon Silverleaf. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
// this is the setter code that is also created with the @synthesize command does not allocate anything
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init];
    return _operandStack;
}
/* - this code is removed as it is the getter
- (void)setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack
}
*/
- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}
- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (void)clearBrain
{
    self.operandStack = nil;
}


- (double)performOperation:(NSString *)operation
{
    double result = 0;
    //calculate result
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]) {
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]) {
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"log"]){
        result = log([self popOperand]);
    }   else if ([operation isEqualToString:@"π"]){
        result = M_PI;
    } else if ([operation isEqualToString:@"e"]){
        result = M_E;
    }
    
    
    [self pushOperand:result];
    
    return result;
    
}


@end
