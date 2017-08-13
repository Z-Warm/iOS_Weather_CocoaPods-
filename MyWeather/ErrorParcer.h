//
//  ErrorParcer.h
//  MyWeather
//
//  Created by zub on 9/13/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorParcer : NSObject

- (NSString*) ParseError: (int) ErrorCode: (NSError*) MyError;

@end
