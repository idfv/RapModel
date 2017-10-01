//
//  RapModelTests.m
//
//  Created by RapKit on 01/10/2017.
//  Copyright © 2017 RapKit. All rights reserved.
//

#import "RapModel.h"

@interface TestsModel : RapModel

@property (nonatomic, copy)     NSString        *rapRightStr;
@property (nonatomic, copy)     NSString        *rapWrongStr;

@property (nonatomic, strong)   NSNumber        *rapRightNum;
@property (nonatomic, strong)   NSNumber        *rapWrongNum;

@property (nonatomic, strong)   NSArray         *rapRightArr;
@property (nonatomic, strong)   NSArray         *rapWrongArr;

@property (nonatomic, strong)   NSDictionary    *rapRightDic;
@property (nonatomic, strong)   NSDictionary    *rapWrongDic;

@property (nonatomic, strong)   NSNumber        *rapNumWithStr;
@property (nonatomic, copy)     NSString        *rapStrWithNum;

@property (nonatomic, strong)   NSObject        *rapObj;

@property (nonatomic, assign)   int              rapInt;
@property (nonatomic, assign)   float            rapFloat;
@property (nonatomic, assign)   BOOL             rapBool;
@property (nonatomic, assign)   char             rapChar;

@end

@implementation TestsModel

@end



#import <XCTest/XCTest.h>

@interface RapModelTests : XCTestCase

@end

@implementation RapModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSLog(@"\n\n========== %@ ==========", self.class);
    
    NSDictionary *json = @{
                           @"rapRightStr":      @"right string.",
                           @"rapWrongStr":      @[],
                           
                           @"rapRightNum":      @(100),
                           @"rapWrongNum":      @[],
                           
                           @"rapRightArr":      @[@"string", @(100)],
                           @"rapWrongArr":      @"arr",
                           
                           @"rapRightDic":      @{@"str": @"string.", @"num": @(100)},
                           @"rapWrongDic":      @"dic",
                           
                           @"rapNumWithStr":    @"100",
                           @"rapStrWithNum":    @100,
                           
                           @"rapObj":           @"obj",
                           
                           @"rapInt":           @1234,
                           @"rapFloat":         @12.34,
                           @"rapBool":          @"true",
                           @"rapChar":          @"yes",
                           
                           @"rapUndefine":      @"Undefine key.",
                           };
    
    // Use RapModel
    TestsModel *model = [[TestsModel alloc] init];
    [model setValuesForKeysWithDictionary:json];
    NSLog(@"rapRightStr: %@", model.rapRightStr);
    NSLog(@"rapWrongStr: %@", model.rapWrongStr);
    
    NSLog(@"rapRightNum: %@", model.rapRightNum);
    NSLog(@"rapWrongNum: %@", model.rapWrongNum);
    
    NSLog(@"rapRightArr: %@", model.rapRightArr);
    NSLog(@"rapWrongArr: %@", model.rapWrongArr);
    
    NSLog(@"rapRightDic: %@", model.rapRightDic);
    NSLog(@"rapWrongDic: %@", model.rapWrongDic);
    
    NSLog(@"rapNumWithStr: %@", model.rapNumWithStr);
    NSLog(@"rapStrWithNum: %@", model.rapStrWithNum);
    
    NSLog(@"rapObj: %@", model.rapObj);
    
    NSLog(@"rapInt: %d", model.rapInt);
    NSLog(@"rapFloat: %f", model.rapFloat);
    NSLog(@"rapBool: %d", model.rapBool);
    NSLog(@"rapChar: %d", model.rapChar);
    
    NSLog(@"\n====================\n\n<%@> Tests End.", self.class);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
