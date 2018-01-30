//  Created by Oleg on 1/30/18.
//  Copyright © 2018 Oleg Hnidets. All rights reserved.
//

#import "OHSettingsViewController.h"
#import <OHMySQL/OHMySQL.h>

@interface OHSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *serverTextField;

@property (weak, nonatomic) IBOutlet UITextField *databaseTextField;

@property (weak, nonatomic) IBOutlet UITextField *socketTextField;

@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@end

@implementation OHSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	OHMySQLStoreCoordinator *coordinator = [OHMySQLContainer sharedContainer].storeCoordinator;

	self.usernameTextField.text = coordinator.user.userName ?: @"root";
	self.passwordTextField.text = coordinator.user.password ?: @"root";
	self.serverTextField.text = coordinator.user.serverName ?: @"localhost";
	self.databaseTextField.text = coordinator.user.dbName ?: @"ohmysql";
	self.portTextField.text = [NSString stringWithFormat:@"%lu", coordinator.user.port != 0 ? coordinator.user.port : 3306];
	self.socketTextField.text = coordinator.user.socket ?: @"/Applications/MAMP/tmp/mysql/mysql.sock";
}

- (IBAction)submit {
	[self configureMySQL];

	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configureMySQL {
	// Check configurations here.
	//	OHSSLConfig *config = [[OHSSLConfig alloc] initWithKey:@"/Users/oleg/Desktop/newcerts/client-key.pem"
	//												  certPath:@"/Users/oleg/Desktop/newcerts/client-cert.pem"
	//											  certAuthPath:@"/Users/oleg/Desktop/newcerts/ca.pem"
	//										   certAuthPEMPath:@"/Users/oleg/Desktop/newcerts/"
	//													cipher:nil];
	// You may delete sslConfig:config if you don't use SSL.
	OHMySQLUser *user = [[OHMySQLUser alloc] initWithUserName:self.usernameTextField.text
													 password:self.passwordTextField.text
												   serverName:self.serverTextField.text
													   dbName:self.databaseTextField.text
														 port:self.portTextField.text.integerValue
													   socket:self.socketTextField.text];
	OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:user];
	[coordinator connect];

	[coordinator setEncoding:CharsetEncodingUTF8MB4];

	OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
	queryContext.storeCoordinator = coordinator;
	[OHMySQLContainer sharedContainer].mainQueryContext = queryContext;
}

@end
