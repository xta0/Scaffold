#encoding:utf-8

module T_View

require 'erb'

#{
# class:xxx
# superclass:xxx 
# itemclass:xxx
#}

def T_View::renderH(hash)

  item = hash["itemclass"]
  template = <<-TEMPLATE
  
<% if item %>@class <%= hash["itemclass"] %>;<% end %>

#import <UIKit/UIKit.h>

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

<% if item %>@property(nonatomic,strong) <%= hash["itemclass"] %> *item;<% end %>

@end

  TEMPLATE

  erb = ERB.new(template)
  erb.result(binding)
  
end

def T_View::renderM(hash)
  
  item = hash["itemclass"]
  template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
<% if item %>#import "<%= hash["itemclass"] %>.h"<% end %>

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (id)initWithFrame:(CGRect)frame 
{

  self = [super initWithFrame:frame]; 

  if (self) { 

    //todo...

  }

  return self;
}
<% if item %>
- (void)setItem:(<%= hash["itemclass"] %> *)item
{
  
}
<% end %>
- (void)layoutSubviews
{
    [super layoutSubviews];
  
  
}

@end

  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
