//
//  ErrorParcer.m
//  MyWeather
//
//  Created by zub on 9/13/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "ErrorParcer.h"

@implementation ErrorParcer

/*Parse error by error code*/
- (NSString*) ParseError: (int) ErrorCode: (NSError*) MyError{
    NSString *ErrorMessage = [[NSString alloc] init];
    
    switch (ErrorCode) {
        case 5:
            ErrorMessage = @"Database not found!";
            break;
        case 10:
            ErrorMessage = @"Database connection error!";
            break;
        case 20:
            ErrorMessage = @"Database select data error!";
            break;
        case 30:
            ErrorMessage = @"Database edit data error!";
            break;
        case 110:
            ErrorMessage = @"Web request error!";
            break;
        default:
            ErrorMessage = @"No message";
            break;
    }
    [self ShowAlertWithError:ErrorMessage:MyError];
    return ErrorMessage;
}
/*Show allert with error message*/
-(UIAlertView*) ShowAlertWithError:(NSString*)MyErrorMessage:(NSError*) Error {
    
    UIAlertView *Alert = [[UIAlertView alloc]
                          initWithTitle: MyErrorMessage
                          message:[Error localizedDescription]
                          delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                          otherButtonTitles:nil];
    [Alert show];
    return Alert;
}


@end
