#encoding:utf-8

module T_ModelTest

require 'erb'

#{
# class:xxx
# superclass:xxx 
# modelclass:xxx
# sdkheader:xxx
#}


def T_ModelTest::renderM(hash)
  
  template = <<-TEMPLATE

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "<%= hash["sdkheader"] %>"
#import "<%= hash["modelclass"] %>.h"

@interface <%= hash["class"] %> : <%= hash["superclass"] %>

@property(nonatomic,strong)<%= hash["modelclass"] %>* testModel;

@end

@implementation <%= hash["class"] %>

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testModel = [<%= hash["modelclass"] %> new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testModel {
  

    __block BOOL waitingForBlock = YES;
    [self.testModel loadWithCompletion:^(<%= hash["modelclass"] %> *model, NSError *error) {
       
      //todo...
      //add some test logic here

        XCTAssert(!error, @"Pass");
        waitingForBlock = NO;
        
    }];
    
    while (waitingForBlock) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
