//
//  FavoriteCities.h
//  MyWeather
//
//  Created by zub on 9/16/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCities : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
-(void) SelectFavoriteCities;
@end
