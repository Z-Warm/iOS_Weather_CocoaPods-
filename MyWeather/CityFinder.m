//
//  CityFinder.m
//  MyWeather
//
//  Created by zub on 9/16/16.
//  Copyright (c) 2016 zub. All rights reserved.
//

#import "CityFinder.h"
#import "DatabaseManager.h"
#import "FavoriteCities.h"

@implementation CityFinder
NSMutableArray *Cities; //Array with Cities
DatabaseManager *DBManager;//Object for manipulation with database
BOOL isSearching;//Searching state flag
FavoriteCities *MyFavoriteCities;//Favorite cities view controller


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Select data from table with all cities and put it into tabble view  */
    self.title = @"All cities";
    [Cities removeAllObjects];
    NSString *SQLRequest = @"select City.CityID, City.CityName from City\
    where City.CityID not in (Select CityID from FavoriteCities)\
    order by City.CityName";
    DBManager = [[DatabaseManager alloc]initWithDBConnection:@"Test3.db"];
    [DBManager SelectData:SQLRequest];
    Cities = [[NSMutableArray alloc]init];
    for (int i = 0; i<DBManager.ResultSet.count; i++){
        [Cities addObject:[[DBManager.ResultSet objectAtIndex:i] valueForKey:@"CityName"]];
    }
    [self.tableView reloadData];
}
    
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    /*Set number of column*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}
/*Preparing of searching result and reload tableView*/
- (void)searchTableList {
    NSString *searchString = _searchBar.text;
    [Cities removeAllObjects];
    [self.tableView reloadData];
    NSString *SQLRequest = [NSString stringWithFormat: @"%@%@%@", @"select City.CityID, City.CityName from City\
    where City.CityName like'%", searchString,@"%'\
    and City.CityID not in (Select CityID from FavoriteCities)\
    order by City.CityName"];\
    [DBManager SelectData:SQLRequest];
    for (int i = 0; i<DBManager.ResultSet.count; i++){
        [Cities  addObject:[[DBManager.ResultSet objectAtIndex:i] valueForKey:@"CityName"]];
    }
    [self.tableView reloadData];
}
/*Start searching on changing text*/
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
    /*The next commented code works, by it needs for using multithreating*/
    /*if([searchText length] != 0) {
        isSearching = YES;
        [self searchTableList];
    }
    else {
        isSearching = NO;
    }
    */
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    //
}
/*Start searching after search button click*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchTableList];
}

/*Set row count*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Cities count];
}
/*Put data into table view*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"Cities";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [Cities objectAtIndex:indexPath.row];
    return cell;
}

/*Pass CityName to WeatherView*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)IndexPath{
    IndexPath = tableView.indexPathForSelectedRow;
    NSString *CityID = [NSString stringWithFormat:@"%@",[[DBManager.ResultSet objectAtIndex: (int)IndexPath.row] valueForKey:@"CityID"]];
    NSString *InsSQLString = [NSString stringWithFormat: @"%@%@%@", @"insert into \
                    FavoriteCities (CityID) Values (", CityID ,@")"];
    if([DBManager UpdateData: InsSQLString]==1){
        NSString *AlertMessage = [NSString stringWithFormat:@"%@ %@",[[DBManager.ResultSet objectAtIndex: (int)IndexPath.row] valueForKey:@"CityName"], @"has been added to faforite list successfully. Press 'OK' for return to favorite list, or 'Again' for add other city." ];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:AlertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Again", nil];
        [alert show];
    }
    [MyFavoriteCities loadView];
}
/*Catch clicked button*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    /*If 'OK' cliched than go to main view*/
    if (buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    /*If 'Again' clicked than reload data for current view*/
    if (buttonIndex == 1){
        [self viewDidLoad];
    }
}

@end
