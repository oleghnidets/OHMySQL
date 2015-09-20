//  Created by Oleg on 2015.
//  Copyright (c) 2015 Oleg Hnidets. All rights reserved.
//

#import "OHViewController.h"

#import "OHMySQL.h"

@interface OHViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordLabel;
@property (nonatomic, strong) OHMySQLQuery *query;

@end

@implementation OHViewController

- (OHMySQLQuery *)query {
    if (!_query) {
        OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root" password:@"root" serverName:@"localhost" dbName:@"RateIt" port:3306 socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
        
        _query = [[OHMySQLQuery alloc] initWithUser:user];
    }
    
    return _query;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ----
    OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:@"root" password:@"root" serverName:@"localhost" dbName:@"RateIt" port:3306 socket:@"/Applications/MAMP/tmp/mysql/mysql.sock"];
    [[OHMySQLManager sharedManager] connectWithUser:user];
    
    NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"users" set:@{ @"name" : @"ABC", @"lastname" : @"ABC", @"password" : @"123456" }]);
    NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"users" set:@{ @"name" : @"BCD", @"lastname" : @"BCD", @"password" : @"123456" }]);
    NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"users" set:@{ @"name" : @"CDE", @"lastname" : @"CDE", @"password" : @"123456" }]);
    NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"users" set:@{ @"name" : @"Oleg", @"lastname" : @"Hnidets", @"password" : @"123456" }]);
    
    NSLog(@"%li", [[OHMySQLManager sharedManager] updateAll:@"users" set:@{ @"name" : @"Stas", @"lastname" : @"Turchynskiy" } condition:@"name='Oleg'"]);
    
    NSLog(@"%@", [[OHMySQLManager sharedManager] selectAll:@"users" condition:nil]);
    NSLog(@"%@", [[OHMySQLManager sharedManager] selectAll:@"users" condition:@"" orderBy:@[@"name", @"id"] ascending:YES]);
    NSDictionary *first = [[[OHMySQLManager sharedManager] selectFirst:@"users" condition:@"" orderBy:@[@"id"] ascending:YES] firstObject];
    NSLog(@"%@", first);
    
    NSLog(@"%li", [[OHMySQLManager sharedManager] insertInto:@"students" set:@{ @"groupId" : @"1", @"userId" : first[@"id"] }]);
    NSLog(@"%@",[[OHMySQLManager sharedManager] selectJoinType:OHJoinRight
                                                          from:@"users"
                                                          join:@"students"
                                                   columnNames:@[@"students.groupID", @"users.name", @"users.lastname"]
                                                   onCondition:@"users.id=students.userId"]);
    
    //    NSLog(@"%li", [[OHMySQLManager sharedManager] deleteAllFrom:@"users" condition:@""]);
    
    // ----
    self.query = [[OHMySQLQuery alloc] initWithUser:user queryString:@"SELECT * FROM users WHERE name='Name'"];
    __unused NSArray *dict = [[OHMySQLManager sharedManager] executeSELECTQuery:self.query];
}

- (IBAction)submitButtonClicked:(UIButton *)sender {
    self.query.queryString = [@"INSERT INTO users (name, lastname, password) VALUES " stringByAppendingFormat:@"('%@', '%@', '%@')",
                              self.nameLabel.text, self.lastNameLabel.text, self.passwordLabel.text];
    
    NSLog(@"%li", [[OHMySQLManager sharedManager] executeQuery:self.query]);
}

- (IBAction)selectButtonClicked:(UIButton *)sender {
    NSLog(@"%@", [[OHMySQLManager sharedManager] selectAllFrom:@"users"]);
}

@end
