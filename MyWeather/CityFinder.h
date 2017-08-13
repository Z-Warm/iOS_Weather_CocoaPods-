//
//  CityFinder.h
//  MyWeather
//
//  Created by zub on 9/16/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoriteCities.h"

@interface CityFinder : UITableViewController<UITableViewDelegate, UITableViewDataSource> {
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchBarController;
@end
