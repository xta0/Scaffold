#encoding:utf-8

module T_ListCell

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   itemclass : xxx
#   height : xxx
# }

def T_ListCell::renderH(hash)
  
item = hash["itemclass"]
template = <<-TEMPLATE
  
#import "<%= hash["superclass"] %>.h"

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListCell::renderM(hash)

item = hash["itemclass"]
template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
<% if item %>#import "<%= hash["itemclass"] %>.h"<% end %>

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //todo: add some UI code
    
        
    }
    return self;
}

+ (CGFloat) tableView:(UITableView *)tableView variantRowHeightForItem:(id)item AtIndex:(NSIndexPath *)indexPath
{
    return <%= hash["height"] %>;
}
<% if item %>
- (void)setItem:(<%= hash["itemclass"] %> *)item
{
    [super setItem:item];
  
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