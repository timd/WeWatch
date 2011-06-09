//
//  Reachable.m
//  WeWatch
//
//  Created by Tim Duckett on 04/06/2011.
//  Copyright 2011 Charismatic Megafauna Ltd. All rights reserved.
//

#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachable.h"
#import "Reachability.h"
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>

@implementation Reachable

-(BOOL)isReachable
{

    return [self hostAvailable:@"wewatch.co.uk"];
    
}

-(id)init{
    
    [super init];
    return self;
    
}

// Direct from Apple. Thank you Apple
- (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address
{
    if (!IPAddress || ![IPAddress length]) return NO;
    
    memset((char *) address, sizeof(struct sockaddr_in), 0);
    address->sin_family = AF_INET;
    address->sin_len = sizeof(struct sockaddr_in);
    
    int conversionResult = inet_aton([IPAddress UTF8String], &address->sin_addr);
    if (conversionResult == 0) {
		NSAssert1(conversionResult != 1, @"Failed to convert the IP address string into a sockaddr_in: %@", IPAddress);
        return NO;
    }
    
    return YES;
}

- (NSString *) getIPAddressForHost: (NSString *) theHost
{
	struct hostent *host = gethostbyname([theHost UTF8String]);
    if (!host) {herror("resolv"); return NULL; }
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	return addressString;
}

- (BOOL) hostAvailable: (NSString *) theHost
{
    
    NSString *addressString = [self getIPAddressForHost:theHost];
    if (!addressString)
      {
        printf("Error recovering IP address from host name\n");
        return NO;
      }
    
    struct sockaddr_in address;
    BOOL gotAddress = [self addressFromString:addressString address:&address];
    
    if (!gotAddress)
      {
		printf("Error recovering sockaddr address from %s\n", [addressString UTF8String]);
        return NO;
      }
    
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);
    SCNetworkReachabilityFlags flags;
    
	BOOL didRetrieveFlags =SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
      {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
      }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    return isReachable ? YES : NO;;
}


@end
