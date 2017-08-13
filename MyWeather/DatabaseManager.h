//
//  DatabaseManager.h
//  MyWeather
//
//  Created by zub on 9/13/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseManager : NSObject
@property (nonatomic, copy) NSString* ErrorMessage;
@property (nonatomic, strong) NSMutableArray* ResultSet;
-(id) initWithDBConnection:(NSString*) DatabaseName;
- (BOOL) SelectData:(NSString*) SelectRequest;
- (BOOL) UpdateData:(NSString*) UpdQuery;

@end
