//
//  CalculatorViewController.m
//  RPN Calculator
//
//  Created by Simon Silverleaf on 8/24/12.
//  Copyright (c) 2012 Simon Silverleaf. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
 
@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredADecimalPoint;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber =
    _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize userHasEnteredADecimalPoint = _userHasEnteredADecimalPoint;
@synthesize history = _history;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)clearPressed
{
    self.display.text =@"0";
    self.history.text =@"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    [self.brain clearBrain];

}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    //NSLog(@"digit pressed = %@", digit);
    //UILabel *myDisplay = self.display; //[self display];
    //NSString *currentText = myDisplay.text; //[myDisplay text];
    //NSString *newText = [currentText stringByAppendingString:digit];
    //myDisplay.text = newText;//[myDisplay setText:newText];
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)enterPressed
{
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length]-1];
        self.history.text = [self.history.text stringByAppendingString:@" "]; 
    }
    self.history.text = [self.history.text stringByAppendingString:self.display.text];
    self.history.text = [self.history.text stringByAppendingString:@" "];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredADecimalPoint = NO;
    
    
}
- (IBAction)backspacePressed
{
    if ([self.display.text hasSuffix:@"."]){
        self.userHasEnteredADecimalPoint = NO;
    }

    self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
    
    if ([self.display.text length] == 0) {
        self.display.text =@"0";
        self.userHasEnteredADecimalPoint = NO;
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}
- (IBAction)changeSignPressed
{
    if ([self.display.text hasPrefix:@"-"]) {
        self.display.text = [self.display.text substringFromIndex:1];
    } else {
        self.display.text = [@"-" stringByAppendingString:self.display.text];
    }
    
}

- (IBAction)decimalPressed:(id)sender
{
    if (self.userHasEnteredADecimalPoint)
    {
        return;
    }
    
    self.userHasEnteredADecimalPoint = YES;
    self.userIsInTheMiddleOfEnteringANumber = YES;
    [self digitPressed:sender];
    
}

 
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    if ([self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text substringToIndex:[self.history.text length]-1];
        self.history.text = [self.history.text stringByAppendingString:@" "];
    }

    self.history.text = [self.history.text stringByAppendingString:sender.currentTitle];
    double result = [self.brain performOperation:sender.currentTitle];
    NSString *resultString = [NSString stringWithFormat:@"%g", result];
    self.display.text = resultString;
    
    if (![self.history.text hasSuffix:@"="]) {
        self.history.text = [self.history.text stringByAppendingString:@"="];
    }
/*    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
*/
}
@end
