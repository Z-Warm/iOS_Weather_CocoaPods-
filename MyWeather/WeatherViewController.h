//
//  WeatherViewController.h
//  MyWeather
//
//  Created by zub on 9/19/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *Label1;
@property (nonatomic, strong) NSString *CityName;
@property (nonatomic, strong) NSString *CityID;
@property (strong, nonatomic) IBOutlet UILabel *CityLabel;//City Name
@property (strong, nonatomic) IBOutlet UILabel *TempLabel;//Current temperature
@property (strong, nonatomic) IBOutlet UILabel *MinMaxLabel;//Minimum and maximum
@property (strong, nonatomic) IBOutlet UILabel *HumidityLabel;//Humidity
@property (strong, nonatomic) IBOutlet UILabel *PreasureLabel;//Preasure
@property (strong, nonatomic) IBOutlet UILabel *WindSpeedLabel;//Wind speed
@property (strong, nonatomic) IBOutlet UILabel *WindDegLabel;//Wind degreese
@property (strong, nonatomic) IBOutlet UIImageView *WeatherImage;//Weather image file
@property (strong, nonatomic) IBOutlet UILabel *WeatherLabel;//Weather description
@property (strong, nonatomic) IBOutlet UILabel *SunriseLabel;
@property (strong, nonatomic) IBOutlet UILabel *SunsetLabel;

@end
