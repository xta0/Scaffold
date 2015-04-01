#encoding:utf-8

module T_ViewController

require 'erb'

# {
#   class:xxx
#   superclass:xxx
#   model:[{name:xx,class:xx},....]
#   logic:{name:xx,class:xx}
# }
def T_ViewController::renderH(hash)
  
  tmplate = <<-TEMPLATE
  
#import "<%= hash["superclass"] %>.h"

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end


def T_ViewController::renderM(hash)

  list = hash["model"]
  tmplate = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
#import "<%= clz %>.h" <% } if list %>

@interface <%= hash["class"] %>()

<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
@property(nonatomic,strong)<%= clz %> *<%= name %>; <% } if list %>

@end

@implementation <%= hash["class"] %>


//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 
<% if list %>
<% list.each{|obj| %>  <% name = obj["name"] %> <% clz  = obj["class"] %>
- (<%= clz %> *)<%= name %>
{
    if (!_<%= name %>) {
        _<%= name %> = [<%= clz %> new];
        _<%= name %>.key = @"__<%= clz %>__";
    }
    return _<%= name %>;
}
<%} %><% end %>


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (void)loadView
{
    [super loadView];
    //todo..
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //todo..
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //todo..
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //todo..
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //todo..
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //todo..
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

-(void)dealloc {
    
    //todo..
}

////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods

- (void)showModel:(VZModel *)model
{
    //todo:
    [super showModel:model];
}

- (void)showEmpty:(VZModel *)model
{
    //todo:
    [super showEmpty:model];
}


- (void)showLoading:(VZModel*)model
{
    //todo:
    [super showLoading:model];
}

- (void)showError:(NSError *)error withModel:(VZModel*)model
{
    //todo:
    [super showError:error withModel:model];
}

@end
 
  TEMPLATE
  
  erb = ERB.new(tmplate)
  erb.result(binding)
  
end

end