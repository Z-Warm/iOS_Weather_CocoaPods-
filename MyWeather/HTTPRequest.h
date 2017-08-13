//
//  HTTPRequest.h
//  MyWeather
//
//  Created by zub on 9/14/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPRequest : NSObject

@property (nonatomic, copy) NSString* ErrorMessage;
-(NSData*) GetDataByRequest: (NSString*) UrlString;
- (NSDictionary*) GetDeserialized: (NSData*) Data;
@end
