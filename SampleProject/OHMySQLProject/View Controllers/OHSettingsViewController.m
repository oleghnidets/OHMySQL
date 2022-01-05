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

	OHMySQLStoreCoordinator *coordinator = OHMySQLContainer.shared.storeCoordinator;

	self.usernameTextField.text = coordinator.configuration.username ?: @"root";
	self.passwordTextField.text = coordinator.configuration.password ?: @"root";
	self.serverTextField.text = coordinator.configuration.serverName ?: @"localhost";
	self.databaseTextField.text = coordinator.configuration.dbName ?: @"ohmysql";
	self.portTextField.text = [NSString stringWithFormat:@"%lu", coordinator.configuration.port != 0 ? coordinator.configuration.port : 3306];
	self.socketTextField.text = coordinator.configuration.socket ?: @"/Applications/MAMP/tmp/mysql/mysql.sock";
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
	OHMySQLConfiguration *user = [[OHMySQLConfiguration alloc] initWithUser:self.usernameTextField.text
													 password:self.passwordTextField.text
												   serverName:self.serverTextField.text
													   dbName:self.databaseTextField.text
														 port:self.portTextField.text.integerValue
													   socket:self.socketTextField.text];
	OHMySQLStoreCoordinator *coordinator = [[OHMySQLStoreCoordinator alloc] initWithConfiguration:user];
    if (![coordinator connect]) {
        NSLog(@"Cannot connect to MySQL server.");
        return ;
    }

	[coordinator setEncoding:CharsetEncodingUTF8MB4];

	OHMySQLQueryContext *queryContext = [OHMySQLQueryContext new];
	queryContext.storeCoordinator = coordinator;
    OHMySQLContainer.shared.mainQueryContext = queryContext;
}

@end
