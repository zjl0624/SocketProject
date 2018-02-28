//
//  ViewController.m
//  UDPSocket
//
//  Created by zjl on 2018/2/28.
//  Copyright © 2018年 zjl. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncUdpSocket.h"
#import "Utils.h"
@interface ViewController () <GCDAsyncUdpSocketDelegate> {
	NSMutableString *resultStr;
}
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (nonatomic,strong) GCDAsyncUdpSocket *udpSocket;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *reciveBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.bindBtn addTarget:self action:@selector(bindBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
	[self.reciveBtn addTarget:self action:@selector(reciveBtnClick) forControlEvents:UIControlEventTouchUpInside];
	self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	resultStr = [[NSMutableString alloc] init];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
	
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(nullable id)filterContext {
	dispatch_async(dispatch_get_main_queue(), ^{
		NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[resultStr appendString:result];
		[resultStr appendString:@"\n"];
		self.resultTextView.text = resultStr;
	});
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag{
	
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
	
}
#pragma mark - private method
- (void)bindBtnClick {
	NSError *error;
	if ([self.udpSocket bindToPort:[self.portTextField.text intValue] error:&error]) {
		[Utils initAlertControllerWithTitle:@"提示" msg:@"绑定端口成功"];
	}else {
		[Utils initAlertControllerWithTitle:@"提示" msg:@"绑定端口失败"];
	}
}


- (void)sendBtnClick {
	
//	[self.udpSocket sendData:[self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding] toAddress:[@"192.168.0.148:6000" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
	[self.udpSocket sendData:[self.contentTextField.text dataUsingEncoding:NSUTF8StringEncoding] toHost:@"192.168.0.148" port:6000 withTimeout:-1 tag:0];
}

- (void)reciveBtnClick {
	NSError *error;
	[self.udpSocket receiveOnce:&error];
}
@end
