//
//  HTTPRequest.m
//  MyWeather
//
//  Created by zub on 9/14/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "HTTPRequest.h"
#import "ErrorParcer.h"

@implementation HTTPRequest

/*Get data by url request*/
-(NSData*) GetDataByRequest: (NSString*) UrlString{
    NSError *error = nil;
    NSData *Data;
    @try{
		NSURLResponse *response = nil;
		NSURL *Url = [NSURL URLWithString: UrlString];
		NSURLRequest *urlRequest =[NSURLRequest requestWithURL:Url];
		Data =[NSURLConnection sendSynchronousRequest:urlRequest        returningResponse:&response
                                                        error:&error];
	}
	@catch(NSError* e){
        self.ErrorMessage = [[ErrorParcer alloc] ParseError:110: e];
        return nil;
	}
	return Data;
}
/*Get deserialized data from jSON*/
- (NSDictionary*) GetDeserialized: (NSData*) Data{
	NSError *error = nil;
    if(Data != nil){
    NSDictionary *deserializedDictionary = (NSDictionary*) [NSJSONSerialization
                                                            JSONObjectWithData:Data options:NSJSONReadingAllowFragments error:&error];
    return deserializedDictionary;
    }
    return nil;
	
}



@end
