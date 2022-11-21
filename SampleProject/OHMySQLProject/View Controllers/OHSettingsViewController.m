//
//  Copyright (c) 2015-Present Oleg Hnidets
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

@import OHMySQL;

#import "OHSettingsViewController.h"

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
	self.socketTextField.text = coordinator.configuration.socket ?: @"/tmp/mysql.sock";
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
