/**
 * Copyright (c) 2015-present, Callstack Sp z o.o.
 * All rights reserved.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import UIKit;
#import "React/RCTEventDispatcher.h"
#import "React/RCTComponent.h"
#import <OpenTok/OpenTok.h>

@interface RCTOpenTokSubscriberView : UIView

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *sessionId;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, copy) RCTDirectEventBlock onSubscribeError;
@property (nonatomic, copy) RCTDirectEventBlock onSubscribeStop;
@property (nonatomic, copy) RCTDirectEventBlock onSubscribeStart;




- (void)sessionDidConnect:(OTSession*)session;
- (void)sessionDidDisconnect:(OTSession*)session;
- (void)session:(OTSession*)session streamCreated:(OTStream *)stream;
- (void)session:(OTSession*)session streamDestroyed:(OTStream *)stream;
- (void)session:(OTSession*)session connectionCreated:(OTConnection *)connection;
- (void)session:(OTSession*)session connectionDestroyed:(OTConnection *)connection;
- (void)session:(OTSession*)session didFailWithError:(OTError*)error;


@end
