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
  
  model_class = hash["modelclass"]
  model_name  = model_class[0].downcase + model_class[1..-1]

  template = <<-TEMPLATE


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "<%= hash["sdkheader"] %>"
#import "<%= hash["modelclass"] %>.h"

@interface <%= hash["class"] %> : <%= hash["superclass"] %>

@property(nonatomic,strong)<%= hash["modelclass"] %>* <%= model_name %>;

@end

@implementation <%= hash["class"] %>

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.<%= model_name %> = [<%= hash["modelclass"] %> new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [self.<%= model_name %> cancel];
    self.<%= model_name %> = nil;
}

- (void)testConnection {
  

    __block BOOL waitingForBlock = YES;
    [self.<%= model_name %> loadWithCompletion:^(<%= hash["modelsuperclass"] %> *model, NSError *error) {
       

        <%= model_class %>* <%= model_name %> = (<%= model_class %>* )model;
        if (!error)
        {
        
        }
        else
        {
            XCTFail(@"Connection Failed:%@",error);
        }

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
