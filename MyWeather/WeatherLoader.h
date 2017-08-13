//
//  WeatherLoader.h
//  MyWeather
//
//  Created by zub on 9/14/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherLoader : NSObject
@property (nonatomic, copy) NSString* ErrorMessage;
-(id) initWithDMManager;
- (NSDictionary*) GetCurrentWeather: (NSString*) City;
- (NSDictionary*) GetForecast: (NSString*) City;

@end
