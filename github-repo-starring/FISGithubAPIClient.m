//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import <AFNetworking.h>
#import <AFOAuth2Manager.h>
#import <AFOAuth2Manager/AFHTTPRequestSerializer+OAuth2.h>

@implementation FISGithubAPIClient
NSString *const GITHUB_API_URL=@"https://api.github.com";

+(BOOL)loggedIn
{
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    return credential != nil;
}

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+(void)getUserRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock
{
    NSString *githubURL = [NSString stringWithFormat:@"%@/user/repos",GITHUB_API_URL];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];

    [manager GET:githubURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Fail: %@",error.localizedDescription);
    }];
}

+(void)checkIfRepoIsStarredWithFullName:(NSString *)fullName CompletionBlock:(void (^)(BOOL))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@",GITHUB_API_URL,fullName];


    // New AF Manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
    // Make the Request
    [manager GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 204 ) {
            completionBlock(YES);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSLog(@"ERROR:%@",error.localizedDescription);
        if (response.statusCode == 404 ) {
            completionBlock(NO);
        }
    }];
}

+(void)changeRepoWithFullName:(NSString *)fullName newName:(NSString *)name CompletionBlock:(void (^)(NSDictionary *))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/repos/%@",GITHUB_API_URL,fullName];


    // New AF Manager
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];

    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    manager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    [manager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];

    NSDictionary *params = @{@"name":name};
    // Make the Request
    [manager PATCH:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseRepo = responseObject;

        completionBlock(responseRepo);
    } failure:nil];
}

+(void)starRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(void))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@",GITHUB_API_URL,fullName, GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    [serializer setAuthorizationHeaderFieldWithCredential:credential];
    manager.requestSerializer = serializer;

    [manager PUT:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAIL:%@",error.localizedDescription);
    }];
}

+(void)unstarRepoWithFullName:(NSString *)fullName CompletionBlock:(void (^)(void))completionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@",GITHUB_API_URL,fullName, GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    AFOAuthCredential *credential =
    [AFOAuthCredential retrieveCredentialWithIdentifier:@"githubToken"];

    [serializer setAuthorizationHeaderFieldWithCredential:credential];
    manager.requestSerializer = serializer;

    [manager DELETE:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAIL:%@",error.localizedDescription);
    }];
}


+ (void)getAccessTokenWithCode:(NSString *)code
{
    NSURL *baseURL = [NSURL URLWithString:@"https://github.com"];
    AFOAuth2Manager *manager = [[AFOAuth2Manager alloc] initWithBaseURL:baseURL clientID:GITHUB_CLIENT_ID secret:GITHUB_CLIENT_SECRET];
    
    manager.useHTTPBasicAuthentication = NO;
    [manager authenticateUsingOAuthWithURLString:@"/login/oauth/access_token"
                                            code:code
                                     redirectURI:@"githubLogin://callback"
                                         success:^(AFOAuthCredential *credential) {
                                             [AFOAuthCredential storeCredential:credential
                                                                 withIdentifier:@"githubToken"];
                                             NSLog(@"Got Access");
                                         } failure:^(NSError *error) {
                                             NSLog(@"Fail: %@",error.localizedDescription);
                                         }];
}

@end
