//
//  WeatherViewController.m
//  MyWeather
//
//  Created by zub on 9/19/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherLoader.h"

@interface WeatherViewController ()

@end

@implementation WeatherViewController

@synthesize CityName;
@synthesize CityID;
//float K = 273.15;//Temperature of absolute zero

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _CityLabel.text = self.CityName;
    self.title = self.CityName;
    NSLog(@"CityINWeatherWiew =  %@",CityName);
   [self LoadCurrent:CityID];
   [self LoadForecast:CityID];
}
/*Elevate current weather data*/
-(BOOL)LoadCurrent:(NSString*)MyCityID{
    WeatherLoader *WLoader = [[WeatherLoader alloc] initWithDMManager];
    _TempLabel.text = @"";
    _MinMaxLabel.text = @"";
    _HumidityLabel.text = @"";
    _PreasureLabel.text = @"";
    _WindSpeedLabel.text = @"";
    _WindDegLabel.text = @"";
    _WeatherLabel.text = @"";
    /*Get current weather by Weather loader*/
    NSLog(@"CityID = %@",CityID);
    if([WLoader GetCurrentWeather:CityID]!=nil){
        
        NSDictionary *WCurrentData = [WLoader GetCurrentWeather:CityID];
        //Evaluate current temperature:
        int Temp = (int)[[WCurrentData valueForKey:@"Temperature"] doubleValue];
       _TempLabel.text = [NSString stringWithFormat:@"%d", (int)Temp];
        //Evaluate minimum and maximum temperature:
        int  TempMin = (int)[[WCurrentData valueForKey:@"TempMin"]doubleValue];
        int  TempMax = (int)[[WCurrentData valueForKey:@"TempMax"]doubleValue];
        _MinMaxLabel.text = [NSString stringWithFormat: @"%d%@%d", TempMin, @"....",TempMax];
        //Evaluate humidity:
        int Humidity = (int)[[WCurrentData valueForKey:@"Humiidity"] intValue];
        _HumidityLabel.text = [NSString stringWithFormat:@"Humidity: %d%%", Humidity];
        //Evaluate preasure:
        int Preasure = (int)[[WCurrentData valueForKey:@"Preasure"] intValue];
        _PreasureLabel.text = [NSString stringWithFormat:@"Preasure: %dmm", Preasure];
        //Evluate wind speed:
        int WindSpeed = (int)[[WCurrentData valueForKey:@"WindSpeed"] intValue];
        _WindSpeedLabel.text = [NSString stringWithFormat:@"Speed: %dm/s", WindSpeed];
        //Evaluate wind degreese:
        float WindDeg = (float)[[WCurrentData valueForKey:@"WindDeg"] floatValue];
        _WindDegLabel.text = [NSString stringWithFormat:@"Deg: %gdeg", WindDeg];
        //Evaluate Sunrise and Sunser:
        _SunriseLabel.text = [WCurrentData valueForKey:@"SunRise"];
        _SunsetLabel.text = [WCurrentData valueForKey:@"SunSet"];
        //Evaluate Weather image:
        NSString *WeatherImg = [WCurrentData valueForKey:@"IconName"];
        WeatherImg = [NSString stringWithFormat:@"%@%@", WeatherImg, @".png"];
        [_WeatherImage setImage:[UIImage imageNamed:WeatherImg]];
        return 1;
        
    }
    return 0;
}
/*Elevate forecast data*/
-(BOOL)LoadForecast:(NSString*)MyCityID{
    WeatherLoader *WLoader = [[WeatherLoader alloc] initWithDMManager];
    //NSLog(@"GetForecast = %@,%@",CityID, [WLoader GetForecast:CityID]);
    NSDictionary *WForecastData = [WLoader GetForecast:CityID];
    if (WForecastData){
        NSLog(@"ForecastData = %@", WForecastData);
    }
    
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
