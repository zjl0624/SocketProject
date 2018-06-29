//
//  ViewController.m
//  Client
//
//  Created by zjl on 2017/6/16.
//  Copyright © 2017年 zjlzjl. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "Utils.h"
@interface ViewController ()<GCDAsyncSocketDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;

@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextField;

@property (strong, nonatomic) GCDAsyncSocket *socket;

- (IBAction)connectAction:(id)sender;

- (IBAction)sendAction:(id)sender;

- (IBAction)receiveAction:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	NSString *str = [NSString stringWithFormat:@"%@:%d",host,port];
	[Utils initAlertControllerWithTitle:@"提示" msg:str];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	self.resultTextField.text = str;
}

- (IBAction)connectAction:(id)sender {
	self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	NSError *error;
	BOOL result = [self.socket connectToHost:self.ipTextField.text onPort:(int)self.portTextField.text error:&error];
	NSString *str = [NSString stringWithFormat:@"连接服务器成功"];
	if (!result) {
		str = @"连接服务器失败";
		[Utils initAlertControllerWithTitle:@"提示" msg:str];
	}

}

- (IBAction)sendAction:(id)sender {
	NSData *data = [self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding];
	[self.socket writeData:data withTimeout:-1 tag:0];
}

- (IBAction)receiveAction:(id)sender {
	[self.contentTextField resignFirstResponder];
	[self.socket readDataWithTimeout:-1 tag:0];
}
@end
