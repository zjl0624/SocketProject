//
//  ViewController.m
//  Server
//
//  Created by zjl on 2017/6/16.
//  Copyright © 2017年 zjlzjl. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "Utils.h"

@interface ViewController ()<GCDAsyncSocketDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;

@property (nonatomic,strong) GCDAsyncSocket *clientSocket;

@property (nonatomic,strong) GCDAsyncSocket *serverSocket;
- (IBAction)startServerAction:(id)sender;
- (IBAction)sendMessageAction:(id)sender;
- (IBAction)receivewAction:(id)sender;


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
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
	[Utils initAlertControllerWithTitle:@"提示" msg:@"连接成功"];
	self.clientSocket = newSocket;
}

- (IBAction)startServerAction:(id)sender {
	self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
	NSError *error;
	BOOL result = [self.serverSocket acceptOnPort:(int)self.portTextField.text error:&error];
	NSString *str;
	if (result) {
		str = [NSString stringWithFormat:@"%@端口开放成功",self.portTextField.text];

	}else {
		str = [NSString stringWithFormat:@"%@端口开放失败",self.portTextField.text];
	}
	[Utils initAlertControllerWithTitle:@"提示" msg:str];

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
	NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	self.resultTextView.text = message;
}
- (IBAction)sendMessageAction:(id)sender {
	NSData *data = [self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding];
	[self.clientSocket writeData:data withTimeout:-1 tag:0];
}
- (IBAction)receivewAction:(id)sender {
	[self.clientSocket readDataWithTimeout:-1 tag:0];
}


@end
