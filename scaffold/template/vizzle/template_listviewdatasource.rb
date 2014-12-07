#encoding:utf-8

module T_ListViewDataSource

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   cellclass:xxx
# }

def T_ListViewDataSource::renderH(hash)
  
  template = <<-TEMPLATE
  
#import "<%= hash["superclass"] %>.h"

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListViewDataSource::renderM(hash)

cell = hash["cellclass"]
template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
<% if cell %>#import "<%= hash["cellclass"] %>.h"<% end %>

@interface <%= hash["class"] %>()

@end

@implementation <%= hash["class"] %>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    //default:
    return 1; 

}

- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{

    //@REQUIRED:
    <% if cell %>
    return [<%= hash["cellclass"] %> class];
    <% else %>
    //todo : return a cell class
    return nil;
    <% end %>

}

//@optional:
//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{

    //default:
    //return [super itemForCellAtIndexPath:indexPath]; 

//}


@end  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


end