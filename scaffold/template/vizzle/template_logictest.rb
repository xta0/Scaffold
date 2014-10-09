#encoding:utf-8

module T_LogicTest

require 'erb'

#{
# class:xxx
# superclass:xxx 
# logicclass:xxx
# sdkheader:xxx
#}


def T_LogicTest::renderM(hash)
  
  template = <<-TEMPLATE

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "<%= hash["sdkheader"] %>.h"
#import "<%= hash["logicclass"] %>.h"

@interface <%= hash["class"] %> : <%= hash["superclass"] %>

@property(nonatomic,strong)<%= hash["logicclass"] %>* logic;

@end

@implementation <%= hash["class"] %>

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.logic = [<%= hash["modelclass"] %> new];
    self.logic.viewController = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    self.logic = nil;
}

- (void)test_logic_view_did_load {

    [self.logic logic_view_did_load];
}

- (void)test_logic_view_will_appear
{
    [self.logic logic_view_will_appear];
}

- (void)test_logic_view_did_appear
{
    [self.logic logic_view_did_appear];
    
}

- (void)test_logic_view_will_disappear
{
    [self.logic logic_view_will_disappear];
    
}

- (void)test_logic_view_did_disappear
{
    [self.logic logic_view_did_disappear];
    
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
