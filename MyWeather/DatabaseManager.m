//
//  DatabaseManager.m
//  MyWeather
//
//  Created by zub on 9/13/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "DatabaseManager.h"
#import "FMDatabase.h"
#import "ErrorParcer.h"

@implementation DatabaseManager
/*Param for local database connection*/
NSArray  *Paths;
NSString *DocsPath;
NSString *DbPath;
FMDatabase *Database;


/*Constructor wit database connection*/

-(id) initWithDBConnection:(NSString*) DatabaseName{
    self = [super init];
    if(self){
        [self GetConnection:DatabaseName];
        self.ErrorMessage = nil;
    }
    return self;
}

/*Get connection to database by database name*/
- (void) GetConnection: (NSString*) Databasename {
    @try {
        Paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        DocsPath = [Paths objectAtIndex:0];
        DbPath = [DocsPath stringByAppendingPathComponent:Databasename];
        /*Connect to database using FMDB*/
        Database = [FMDatabase databaseWithPath:DbPath];
        if(Database == nil) [NSException raise:@"Database connect error" format:@""];
    }
    @catch(NSException *e){
        self.ErrorMessage = [[ErrorParcer alloc] ParseError:5:Database.lastError];
    }
}

/*Do select from database and evaluate result*/
- (BOOL) SelectData:(NSString*) SelectRequest{
    int ErrCode = 0;
    @try{
        [Database open];
        if(Database == nil){
         ErrCode = 5;
         [NSException raise:@"Database connect error" format:@""];
        }
        FMResultSet *Results = [Database executeQuery:SelectRequest];
        if(!Results) {
            ErrCode = 20;
            [NSException raise:@"SQL select error" format:@""];
        }
        self.ResultSet = [NSMutableArray array];
        while ([Results next]) {
            [self.ResultSet addObject:[Results resultDictionary]];
        }
        return  1;
    }
    @catch(NSException* e){
        self.ErrorMessage = [[ErrorParcer alloc] ParseError:ErrCode:Database.lastError];
        return 0;
    }
    @finally{
        [Database close];
    }
  
}

/*Execute query for insert, update and delete data*/
- (BOOL) UpdateData:(NSString*) UpdQuery {
    BOOL Success = 0;
    @try{
        [Database open];
        Success = [Database executeUpdate:UpdQuery];
        if(!Success) {
            [NSException raise:@"SQL execute error" format:@""];
        }
    }
    @catch(NSException* e){
        self.ErrorMessage = [[ErrorParcer alloc] ParseError:30:Database.lastError];
    }
    @finally{
        [Database close];
        return Success;
    }
}

@end
