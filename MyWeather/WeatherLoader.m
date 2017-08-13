//
//  WeatherLoader.m
//  MyWeather
//
//  Created by zub on 9/14/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "WeatherLoader.h"
#import "DatabaseManager.h"
//#import "HTTPRequest.h"
#import "ErrorParcer.h"
#import "OWMWeatherAPI.h"


@implementation WeatherLoader
NSString* AppiID = @"0c202799efa4f150fe91de08f9080fe8";//Personal Api Id
NSString* WDBName = @"Test3.db";//Local SQLite database name

DatabaseManager *WDBManager;
-(id) initWithDMManager{
    self = [super init];
    if(self){
        WDBManager = [[DatabaseManager alloc]initWithDBConnection:WDBName];
    }
    return self;
}

/*Define what is current data show from (from Web or local database)*/
- (NSDictionary*) GetCurrentWeather: (NSString*)City{
    [self GetCurrentByUrl: City];
    if([self GetCurrentFromDB:City]!= nil){
        /*Show current data from databasse if exists*/
        return [self GetCurrentFromDB : City];
    }else{
        /*Handle error if no data for show*/
        return nil;
    }
}
/*Define what is forecast data show from (from Web or local database)*/
- (NSMutableArray*)GetForecast:(NSString*)City{
    [self GetForecastByUrl: City];
    if([self GetForecastFromDB: City]){
        /*Show forecast data from databasse if exists*/
        return [self GetForecastFromDB: City];
    }else{
        /*Handle error if no data for show*/
        self.ErrorMessage = [[ErrorParcer alloc] ParseError:230:nil];
        return nil;
    }
    
}
/*Get current weather in JSON format using CocoaPod OpenWeatherMap*/
- (void) GetCurrentByUrl:(NSString*)City{
    OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:AppiID];
    //Set Celcius temperature format
    [weatherAPI setTemperatureFormat:kOWMTempCelcius];
    //Get current data
    [weatherAPI currentWeatherByCityId:City withCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            // handle the error
            self.ErrorMessage = [[ErrorParcer alloc] ParseError:110:error];
            return;
        }
        //Put current weather into database
        [self PutCurrentToDB: City : result];
    }];
}

/*Get forecast in JSON format using CocoaPod Open*/
- (void)GetForecastByUrl:(NSString*)City{
    OWMWeatherAPI *weatherAPI = [[OWMWeatherAPI alloc] initWithAPIKey:AppiID];
    //Set Celcius temperature format
    [weatherAPI setTemperatureFormat:kOWMTempCelcius];
    //Get forecast data
    [weatherAPI  dailyForecastWeatherByCityId:City withCount:1 andCallback:^(NSError *error, NSDictionary *result) {
        if (error) {
            //handle the error
            self.ErrorMessage = [[ErrorParcer alloc] ParseError:110:error];
            return;
        }
        //Put forecast into database
        [self PutForecastToDB: City : result];
    }];
}
/*Get current weather from the local SQLite database*/
- (NSDictionary*)GetCurrentFromDB:(NSString*)CityID{
    /*Make SQL request for select current weather data*/
	NSString *SelectCurrent =[NSString stringWithFormat: @"%@ %@ %@ %@", @"Select * from CurrentWeather where CityID =", CityID,
                              @" and DateSaving =", [self FormatDate:[[NSDate alloc] init]:false ]];
    [WDBManager SelectData:SelectCurrent];
    /*Return first fow, because in select current city and date
     shoul be only one record*/
    if([WDBManager.ResultSet count]>0)
        return [WDBManager.ResultSet objectAtIndex:0];
    else return nil;
}
/*Get current forecast from the local SQLite database*/
- (NSMutableArray*)GetForecastFromDB:(NSString*)CityID{
    /*Make SQL request for select forecast data*/
    NSString *SelectCurrent =[NSString stringWithFormat: @"%@ %@ %@ %@ %@", @"Select * from ForecastWeather where CityID =", CityID,
                              @"and DateSaving =", [self FormatDate:[[NSDate alloc] init]:false ], @"order by DateForecast desc"];
    [WDBManager SelectData:SelectCurrent];
    return WDBManager.ResultSet;
}
/*Put selected by URL current weather into local SQLite database*/
- (BOOL) PutCurrentToDB:(NSString*)CityID:(NSDictionary*)Current{
    BOOL Success = 0;
    //Delete previous current weather data today for this city //
    NSString *DeleteCurrent = [NSString stringWithFormat: @"%@ %@ %@ %@",
                               @"delete from CurrentWeather \
                               where CurrentWeather.CityID ="
                               ,CityID
                               ,@"and CurrentWeather.DateSaving ="
                               , [self FormatDate:[[NSDate alloc]init]:false]];
    Success = [WDBManager UpdateData: DeleteCurrent];
    if (Success){
        //remake icon file name from nsarray to nsstring//
        NSArray *IconName = [[Current objectForKey:@"weather"]valueForKey:@"icon"] ;
        NSString *ImgFileName = @"";
        for (int i = 0; i<[IconName count];i++){
            ImgFileName = [NSString stringWithFormat:@"%@%@", ImgFileName, [IconName objectAtIndex:i]];
        }
        //Make SQL request for insert current data//
        NSString *InsertCurrent = [NSString stringWithFormat: @"%@(%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,'%@' )",
            @"insert into CurrentWeather \
                (CityID\
                ,DateSaving\
                ,Temperature\
                ,WindSpeed\
                ,WindDeg\
                ,Humiidity\
                ,Preasure\
                ,TempMin\
                ,TempMax\
                ,SunRise\
                ,SunSet\
                ,IconName\
                ) values"
                 , CityID //
                 , [self FormatDate:[[NSDate alloc]init]:false]
                 , [[Current objectForKey:@"main"]valueForKey:@"temp"] //Current temperature
                 , [[Current objectForKey:@"wind"]valueForKey:@"speed"]//Wind speed
                 , [[Current objectForKey:@"wind"]valueForKey:@"deg"]//Wind degrees
                 , [[Current objectForKey:@"main"]valueForKey:@"humidity"]//Humidity
                 , [[Current objectForKey:@"main"]valueForKey:@"pressure"]//Preasure
                 , [[Current objectForKey:@"main"]valueForKey:@"temp_min"]//TempMin
                 , [[Current objectForKey:@"main"]valueForKey:@"temp_max"]//TempMax
                 , [self FormatDate:[[Current objectForKey:@"sys"]valueForKey:@"sunrise"]:true]//Sunrise
                 , [self FormatDate:[[Current objectForKey:@"sys"]valueForKey:@"sunset"]:true]//Sunset
                 , ImgFileName //IconName
                    ];
        Success = [WDBManager UpdateData: InsertCurrent];
    }
    return Success;
}
/*Put selected by URL forecast into local SQLite database*/
- (BOOL) PutForecastToDB:(NSString*)PutCityID:(NSDictionary*)Forecast{
	if(Forecast){
        BOOL Success = 0;
        NSArray *ForecastValues = [Forecast objectForKey:@"list"];
        /*Delete previous forecast weather data today for this city */
        NSString *DeleteForecast = [NSString stringWithFormat: @"%@ %@ %@ %@",
                                    @"delete from ForecastWeather \
                                    where ForecastWeather.CityID ="
                                    ,PutCityID
                                    ,@"and ForecastWeather.DateSaving <="
                                    , [self FormatDate:[[NSDate alloc]init]:false]];
        if([WDBManager UpdateData: DeleteForecast]){
            for(int i=0; i<ForecastValues.count ; i++){
                NSDictionary *Dict = [ForecastValues objectAtIndex:i];
                NSString *TempMin = [[Dict objectForKey:@"main"]valueForKey:@"temp_min"];
                NSString *TempMax = [[Dict objectForKey:@"main"]valueForKey:@"temp_max"];
                NSString *TempDay = [[Dict objectForKey:@"main"]valueForKey:@"temp"];
                NSString *TempNight = @"0";
                NSArray *IconName = [[Dict objectForKey:@"weather"]valueForKey:@"icon"] ;
                NSString *ImgFileName = @"";
                for(int i = 0; i<[IconName count];i++){
                    ImgFileName = [NSString stringWithFormat:@"%@%@", ImgFileName, [IconName objectAtIndex:i]];
                }
                /*Make SQL request for insert forecast data*/
                    NSString *InsertForecast = [NSString stringWithFormat: @"%@(%@,%@,%@,%@,%@,%@,%@,'%@')",
                                            @"insert into ForecastWeather \
                                            (CityID\
                                            ,DateSaving\
                                            ,DateForecast\
                                            ,TempMin\
                                            ,Temp_Max\
                                            ,TempDay\
                                            ,TempNight\
                                            ,Icon\
                                               ) values"
                                            , PutCityID //City ID
                                            , [self FormatDate:[[NSDate alloc]init]:false]//Current date
                                            , [self FormatDate:[Dict objectForKey:@"dt"]:2]//Forecast day
                                            , TempMin//Minimal temperature for forecast day
                                            , TempMax//Maximal temperature for forecast day
                                            , TempDay//Minimal temperature for forecast day
                                            , TempNight//Maximal temperature for forecast day
                                            , ImgFileName//Icon with weather condition
                                               ];
                Success = Success + [WDBManager UpdateData: InsertForecast];
            }
        }
        if(Success) return Success;
    }
    return 0;
}
/*Format date to string*/
- (NSString*)FormatDate:(NSDate*)Date:(int)IsTime{
    NSDateFormatter *Formatter;
    NSString        *DateString;
    Formatter = [[NSDateFormatter alloc] init];
    if(IsTime == 0)[Formatter setDateFormat:@"dd.MM.yyyy"];
    if(IsTime == 1)[Formatter setDateFormat:@"HH:mm:SS"];
    if(IsTime == 2)[Formatter setDateFormat:@"dd.MM.yyyy HH:mm:SS"];
    DateString = [Formatter stringFromDate:Date];
    DateString = [NSString stringWithFormat: @"'%@'",DateString];
    return DateString;
}


@end
