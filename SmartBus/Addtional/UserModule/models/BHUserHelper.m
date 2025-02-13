//
//  BHUserHelper.m
//  SmartBus
//
//  Created by JaeHee on 13-10-25.
//  Copyright (c) 2013年 launching. All rights reserved.
//

#import "BHUserHelper.h"
#import "BHTrendsModel.h"
#import "BHPhotoModel.h"

@implementation BHUserHelper

@synthesize user, authCode, nodes, succeed;

- (void)load
{
    user = [[BHUserModel alloc] init];
    self.nodes = [NSMutableArray arrayWithCapacity:0];
    [super load];
}

- (void)unload
{
    SAFE_RELEASE(user)
    SAFE_RELEASE(nodes);
    [super unload];
}

- (void)check:(NSString *)phone
{
    self
    .HTTP_GET( BHDomain)
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"checkPhone" )
    .PARAM( @"phone", phone )
    .PARAM( @"key", [BHUtil encrypt:phone method:@"checkPhone"] )
    .USER_INFO( @"checkPhone" )
    .TIMEOUT( 10 );
}

- (void)sendMessage:(NSString *)phone
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"sendVailcode" )
    .PARAM( @"phone", phone )
    .PARAM( @"key", [BHUtil encrypt:phone method:@"sendVailcode"] )
    .USER_INFO( @"sendVailcode" )
    .TIMEOUT( 10 );
}

- (void)registerUserInfo:(BHUserModel *)userinfo
{
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"register" )
    .PARAM( @"password", [userinfo.password MD5] )
    .PARAM( @"phone", userinfo.uphone )
    .PARAM( @"uname", userinfo.uname )
    .PARAM( @"gender", [NSNumber numberWithInt:userinfo.ugender] )
    .PARAM( @"key", [BHUtil encrypt:userinfo.uphone method:@"register"] )
    .USER_INFO( @"register" )
    .TIMEOUT( 10 );
}

- (void)login:(NSString *)phone password:(NSString *)pwd
{
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"login" )
    .PARAM( @"phone", phone )
    .PARAM( @"password", [pwd MD5])
    .PARAM( @"key", [BHUtil encrypt:phone method:@"login"] )
    .USER_INFO( @"login" )
    .TIMEOUT( 10 );
}

- (void)getUserInfo:(NSInteger)uid shower:(NSInteger)mid
{
    if ( uid == 0 || mid == 0 ) return;
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"show" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"show"] )
    .USER_INFO ( @"getUserInfo" )
    .TIMEOUT( 10 );
}

- (void)getUserDetail:(NSInteger)uid shower:(NSInteger)mid
{
    if ( uid == 0 || mid == 0 ) return;
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"userinfo" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"userinfo"] )
    .USER_INFO ( @"getUserDetail" )
    .TIMEOUT( 10 );
}

- (void)updateUserInfo:(BHUserModel *)userinfo withUserID:(NSInteger)uid
{
    self
    .HTTP_POST( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"UpdateUser" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"uname", userinfo.uname )
    .PARAM( @"gender", [NSNumber numberWithInt:userinfo.ugender] )
    .PARAM( @"location", userinfo.location )
    .PARAM( @"intro", userinfo.signature )
    .PARAM( @"job", userinfo.profession )
    .PARAM( @"birth", userinfo.birth )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"UpdateUser"] )
    .USER_INFO ( @"updateUserInfo" )
    .TIMEOUT( 10 );
}

- (void)uploadUserAvator:(UIImage *)image withUserId:(NSInteger)uid
{
    if ( uid == 0 ) return;
    
    NSData *imgData = UIImageJPEGRepresentation(image, 0.5);
    
    self
    .HTTP_POST ( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"upload_face" )
    .PARAM( @"mid", [NSNumber numberWithInt:uid] )
    .FILE( [NSString stringWithFormat:@"avator%f.PNG", [[NSDate date] timeIntervalSince1970]], imgData )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"upload_face"] )
    .USER_INFO( @"uploadAvator" )
    .TIMEOUT( 40 );
}

- (void)updatePassword:(NSString *)pwd atPhone:(NSString *)phone
{
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"UpdatePswd" )
    .PARAM( @"phone", phone )
    .PARAM( @"password", [pwd MD5] )
    .PARAM( @"key", [BHUtil encrypt:phone method:@"UpdatePswd"] )
    .USER_INFO ( @"forgotPassword" )
    .TIMEOUT( 10 );
}

- (void)updatePassword:(NSString *)pwd oldPassword:(NSString *)oldpwd atPhone:(NSString *)phone
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"ModifyPswd" )
    .PARAM( @"mid", str_mid )
    .PARAM( @"newpswd", [pwd MD5] )
    .PARAM( @"password", [oldpwd MD5] )
    .PARAM( @"key", [BHUtil encrypt:str_mid method:@"ModifyPswd"] )
    .USER_INFO ( @"modifyPassword" )
    .TIMEOUT( 10 );
}

- (void)getUserAlbums:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page
{
    if ( uid == 0 || mid == 0 ) return;
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"photos" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"photos"] )
    .USER_INFO ( @"getUserAlbums" )
    .TIMEOUT( 10 );
}

- (void)toggleFocus:(BOOL)toggle to:(NSInteger)uid from:(NSInteger)mid
{
    if ( uid == 0 || mid == 0 ) return;
    
    NSString *method = toggle ? @"follow_create" : @"follow_destroy";
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", method )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:method] )
    .USER_INFO ( toggle ? @"addFocus" : @"delFocus" )
    .TIMEOUT( 10 );
}

- (void)getFocus:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page
{
    if ( uid == 0 || mid == 0 ) return;
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"user_following" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"user_following"] )
    .USER_INFO ( @"getFocus" )
    .TIMEOUT( 10 );
}

- (void)getFans:(NSInteger)uid shower:(NSInteger)mid atPage:(NSInteger)page
{
    if ( uid == 0 || mid == 0 ) return;
    
    self
    .HTTP_GET( BHDomain )
    .PARAM( @"app", @"api" )
    .PARAM( @"mod", @"User" )
    .PARAM( @"act", @"user_followers" )
    .PARAM( @"user_id", [NSNumber numberWithInt:uid] )
    .PARAM( @"mid", [NSNumber numberWithInt:mid] )
    .PARAM( @"page", [NSNumber numberWithInt:page] )
    .PARAM( @"count", [NSNumber numberWithInt:kPageSize] )
    .PARAM( @"key", [BHUtil encrypt:[NSString stringWithFormat:@"%d", uid] method:@"user_followers"] )
    .USER_INFO ( @"getFans" )
    .TIMEOUT( 10 );
}

- (void)getStationChecks
{
    NSString *str_mid = [NSString stringWithFormat:@"%d", [BHUserModel sharedInstance].uid];
    NSString *enc = [BHUserModel sharedInstance].uid > 0 ? str_mid : @"1";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];
    [parameters setObject:str_mid forKey:@"mid"];
    [parameters setObject:[BHUtil encrypt:enc method:@"getStationCheckList"] forKey:@"key"];
    
    self
    .HTTP_GET( [BHUtil urlStringWithMethod:@"getStationCheckList" parameters:parameters] )
    .USER_INFO( @"getStationCheckList" )
    .TIMEOUT( 10 );
}


#pragma mark -
#pragma mark NetworkRequestDelegate

- (void)handleRequest:(BeeHTTPRequest *)request
{
    [super handleRequest:request];
    
    if ( request.succeed )
	{
        NSDictionary *result = [request.responseString objectFromJSONString];
        
        if ( ![request.userInfo is:@"uploadAvator"] )
        {
            if ( [result[@"message"][@"code"] integerValue] > 0 )
            {
                NSLog(@"[EROOR]%@_%@", request.userInfo, result[@"message"][@"text"]);
                self.succeed = NO;
                return;
            }
            else
            {
                self.succeed = YES;
            }
        }
        else
        {
            if ( [result[@"status"] integerValue] != 1 )
            {
                self.succeed = NO;
                return;
            }
            else
            {
                self.succeed = YES;
            }
        }
        
        if ([request.userInfo is:@"checkPhone"])
        {
            //TODO:
        }
		else if ([request.userInfo is:@"sendVailcode"])
        {
            self.authCode = result[@"data"][@"Code"];
            NSLog(@"auth code : %@", self.authCode);
        }
        else if ([request.userInfo is:@"register"])
        {
            NSDictionary *data = result[@"data"];
            [BHUserModel sharedInstance].uid = [data[@"uid"] integerValue];
            [BHUserModel sharedInstance].uname = [data[@"uname"] asNSString];
            [BHUserModel sharedInstance].ugender = [data[@"gender"] integerValue];
            [BHUserModel sharedInstance].avator = [data[@"avatar"] asNSString];
            [BHUtil saveUserID:[BHUserModel sharedInstance].uid];
        }
        else if ([request.userInfo is:@"login"])
        {
            NSDictionary *data = result[@"data"];
            [BHUserModel sharedInstance].uid = [data[@"uid"] integerValue];
            [BHUserModel sharedInstance].uname = [data[@"uname"] asNSString];
            [BHUserModel sharedInstance].ugender = [data[@"gender"] integerValue];
            [BHUserModel sharedInstance].avator = [data[@"avatar"] asNSString];
            [BHUtil saveUserID:[BHUserModel sharedInstance].uid];
        }
        else if ([request.userInfo is:@"getUserInfo"])
        {
            NSDictionary *data = [result objectForKey:@"data"];
            self.user.uid = [[data objectForKey:@"uid"] integerValue];
            self.user.uname = [data objectForKey:@"nickname"];
            self.user.avator = [data objectForKey:@"headpic"];
            self.user.ugender = [[data objectForKey:@"gender"] integerValue];
            self.user.bbsnum = [[data objectForKey:@"bbsnum"] integerValue];
            self.user.fansnum = [[data objectForKey:@"fansnum"] integerValue];
            self.user.attnum = [[data objectForKey:@"attentionnum"] integerValue];
            self.user.picnum = [[data objectForKey:@"picnum"] integerValue];
            self.user.focused = [[data objectForKey:@"following"] integerValue];
            self.user.score = [[data objectForKey:@"score"] asNSString];
        }
        else if ( [request.userInfo is:@"getUserDetail"] )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            self.user.uid = [[data objectForKey:@"uid"] integerValue];
            self.user.uname = [[data objectForKey:@"uname"] asNSString];
            self.user.avator = [[data objectForKey:@"avatar_middle"] asNSString];
            self.user.birth = [[data objectForKey:@"birth"] asNSString];
            self.user.uemail = [[data objectForKey:@"email"] asNSString];
            self.user.ugender = [[data objectForKey:@"gender"] integerValue];
            self.user.signature = [[data objectForKey:@"intro"] asNSString];
            self.user.profession = [[data objectForKey:@"job"] asNSString];
            self.user.location = [[data objectForKey:@"location"] asNSString];
            self.user.score = [[data objectForKey:@"score"] asNSString];
        }
        else if ( [request.userInfo is:@"updateUserInfo"] )
        {
            //TODO:
        }
        else if ( [request.userInfo is:@"uploadAvator"] )
        {
            NSDictionary *data = [result objectForKey:@"data"];
            [BHUserModel sharedInstance].avator = [data[@"middle"] asNSString];
        }
        else if ( [request.userInfo is:@"forgotPassword"] )
        {
            //TODO:
        }
        else if ( [request.userInfo is:@"modifyPassword"] )
        {
            //TODO:
        }
        else if ( [request.userInfo is:@"getUserAlbums"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSArray *data in datas)
            {
                BHPhotoModel *photo = [[BHPhotoModel alloc] init];
                for (NSDictionary *imginfo in data) {
                    photo.dtime = [imginfo objectForKey:@"dtime"];
                    [photo.links addObject:[[imginfo objectForKey:@"savepath"] asNSString]];
                }
                [self.nodes addObject:photo];
                [photo release];
            }
        }
        else if ( [request.userInfo is:@"addFocus"] )
        {
            //TODO:
        }
        else if ( [request.userInfo is:@"delFocus"] )
        {
            //TODO:
        }
        else if ( [request.userInfo is:@"getFocus"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHUserModel *userModel = [[BHUserModel alloc] init];
                userModel.uid = [[data objectForKey:@"uid"] integerValue];
                userModel.uname = [data objectForKey:@"uname"];
                userModel.ugender = [[data objectForKey:@"gender"] integerValue];
                userModel.avator = [data objectForKey:@"avatar"];
                userModel.focused = 1;
                [self.nodes addObject:userModel];
                [userModel release];
            }
        }
        else if ( [request.userInfo is:@"getFans"] )
        {
            [self.nodes removeAllObjects];
            
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHUserModel *userModel = [[BHUserModel alloc] init];
                userModel.uid = [[data objectForKey:@"uid"] integerValue];
                userModel.uname = [data objectForKey:@"uname"];
                userModel.ugender = [[data objectForKey:@"gender"] integerValue];
                userModel.avator = [data objectForKey:@"avatar"];
                userModel.focused = [[data objectForKey:@"following"] integerValue];
                [self.nodes addObject:userModel];
                [userModel release];
            }
        }
        else if ( [request.userInfo is:@"getStationCheckList"] )
        {
            NSArray *datas = [result objectForKey:@"data"];
            for (NSDictionary *data in datas)
            {
                BHCheckModel *check = [[BHCheckModel alloc] init];
                check.ctime = [data objectForKey:@"ctime"];
                check.staid = [[data objectForKey:@"station_id"] integerValue];
                check.userid = [[data objectForKey:@"uid"] integerValue];
                check.coor = CLLocationCoordinate2DMake([data[@"gd_lat"] doubleValue], [data[@"gd_long"] doubleValue]);
                [self.nodes addObject:check];
                [check release];
            }
        }
	}
	else if ( request.failed )
	{
    }
}

@end
