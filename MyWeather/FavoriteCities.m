//
//  FavoriteCities.m
//  MyWeather
//
//  Created by zub on 9/16/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "FavoriteCities.h"
#import "DatabaseManager.h"
#import "WeatherViewController.h"
#import "CityFinder.h"

@implementation FavoriteCities
NSMutableArray *Cities;//Array with favorite cities
DatabaseManager *DBManager;//Obgect for manipulation with database
int SelectedIndex;//Index, which is selected on table view

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Favorite cities";
}
/*Select favorite cities and put it into the table view*/
-(void) viewDidAppear:(BOOL)animated{
    animated = YES;
    [self SelectFavoriteCities];
}
/*Go to cities list for add new favorite cities*/
-(void) performAdd{
    CityFinder *FindCity = [[CityFinder alloc]initWithNibName:@"CityFinder" bundle:nil];
    [self.navigationController pushViewController:FindCity animated:YES];
}
/*Select data from database table with favorite cities and put it into tabble view */
-(void) SelectFavoriteCities{
    [Cities removeAllObjects];
    //Prepare and execute sql request:
    NSString *SQLRequest = @"select City.CityID, City.CityName from City \
    where City.cityID in \
    (select CityID from FavoriteCities) order by City.CityName";
    DBManager = [[DatabaseManager alloc] initWithDBConnection:@"Test3.db"];
    if([DBManager SelectData:SQLRequest] == 1){
        //Binding data if request is successfull:
        Cities = [[NSMutableArray alloc]init];
        for (int i = 0; i<DBManager.ResultSet.count; i++){
            [Cities addObject:[[DBManager.ResultSet objectAtIndex:i] valueForKey:@"CityName"]];
        }
        [self.tableView reloadData];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
/*Set number of column for the tableview*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; //Return the number of sections
}

/*Set row count for the tableview*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [Cities count];//Return the number of rows
}

/*Put data into the tableview*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Cities";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [Cities objectAtIndex:indexPath.row];
    return cell;
}

/*Pass CityName to WeatherView*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)IndexPath
{
    WeatherViewController *WeatherWindow = [[WeatherViewController alloc] initWithNibName:@"WeatherViewController" bundle: nil];
    IndexPath = tableView.indexPathForSelectedRow;
    UITableViewCell *currCell = [tableView cellForRowAtIndexPath:IndexPath];
    SelectedIndex = (int)IndexPath.row;
    NSString *CityID = [NSString stringWithFormat:@"%@",[[DBManager.ResultSet objectAtIndex: SelectedIndex] valueForKey:@"CityID"]];
    WeatherWindow.CityName = currCell.textLabel.text;
    WeatherWindow.CityID = CityID;
    [self.navigationController pushViewController:WeatherWindow animated:YES];
}

/*Provide editing row in tableview*/
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)IndexPath {
    SelectedIndex = (int)IndexPath.row;
    return YES;
}

/*Provide deleting tata from table view*/
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)DelIndexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *CityID = [NSString stringWithFormat:@"%@",[[DBManager.ResultSet objectAtIndex: SelectedIndex] valueForKey:@"CityID"]];//Get CitiID from DataSource by current index
        NSString *DelSQLString = [NSString stringWithFormat: @"%@ %@", @"delete from \
                                  FavoriteCities where CityID =", CityID];
        if([DBManager UpdateData: DelSQLString]==1){
            [self SelectFavoriteCities];// refresh data in table view
        }
    }
}

@end
