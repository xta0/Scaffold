#encoding:utf-8

module T_ListViewController

require 'erb'

hash = ARGV[0]

# {
#   class:xxx
#   superclass:xxx
#   model:[{name:xx,class:xx},....]
#   datasource:{name:xxx,class:xxx,superclass:xxx}
#   delegate:{name:xxx,class:xxx,superclass:xxx}
#   logic :{class:xxx,name:xxx}
# }
def T_ListViewController::renderH(hash)
  
  template = <<-TEMPLATE
  
#import "<%= hash["superclass"] %>.h"

@interface <%=hash["class"] %> : <%= hash["superclass"] %>

@end
  
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end


def T_ListViewController::renderM(hash)

  list  = hash["model"]
  dl    = hash["delegate"]
  ds    = hash["datasource"]
  template = <<-TEMPLATE

#import "<%= hash["class"] %>.h"
<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
#import "<%= clz %>.h" <% } if list%>
<% if ds %>#import "<%= hash["datasource"]["class"] %>.h"<% end %>
<% if dl %>#import "<%= hash["delegate"]["class"] %>.h"<% end %>

@interface <%= hash["class"] %>()

<% list.each{|obj| %><% name = obj["name"] %> <% clz  = obj["class"] %>
@property(nonatomic,strong)<%= clz %> *<%= name %>; <% } if list %>
<% if ds %>@property(nonatomic,strong)<%= hash["datasource"]["class"] %> *<%= hash["datasource"]["name"] %>;<% end %>
<% if dl %>@property(nonatomic,strong)<%= hash["delegate"]["class"] %> *<%= hash["delegate"]["name"] %>;<% end %>

@end

@implementation <%= hash["class"] %>

//////////////////////////////////////////////////////////// 
#pragma mark - setters 



//////////////////////////////////////////////////////////// 
#pragma mark - getters 

<% list.each{|obj| %>  <% name = obj["name"] %> <% clz  = obj["class"] %>
- (<%= clz %> *)<%= name %>
{
    if (!_<%= name %>) {
        _<%= name %> = [<%= clz %> new];
        _<%= name %>.key = @"__<%= clz %>__";
    }
    return _<%= name %>;
}
<%} %>
<% if ds %>
- (<%= hash["datasource"]["class"] %> *)<%= hash["datasource"]["name"] %>{

  if (!_<%= hash["datasource"]["name"] %>) {
      _<%= hash["datasource"]["name"] %> = [<%= hash["datasource"]["class"] %> new];
   }
   return _<%= hash["datasource"]["name"] %>;
}
<% end %>
<% if dl %> 
- (<%= hash["delegate"]["class"] %> *)<%= hash["delegate"]["name"] %>{

  if (!_<%= hash["delegate"]["name"] %>) {
      _<%= hash["delegate"]["name"] %> = [<%= hash["delegate"]["class"] %> new];
   }
   return _<%= hash["delegate"]["name"] %>;
}
<% end %>

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - life cycle methods

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //1,config your tableview
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.separatorStyle = YES;
    
    //2,set some properties:下拉刷新，自动翻页
    self.needLoadMore = NO;
    self.needPullRefresh = NO;

    <% if ds && dl %>
    //3，bind your delegate and datasource to tableview
    self.dataSource = self.ds;
    self.delegate = self.dl;
    <% end %>

    //4,@REQUIRED:YOU MUST SET A KEY MODEL!
    //self.keyModel = self.model;
    
    //5,REQUIRED:register model to parent view controller
    //[self registerModel:self.keyModel];

    //6,Load Data
    //[self load];
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
#pragma mark - @override methods - VZViewController


////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - @override methods - VZListViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //todo...
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{

  //todo:... 

}

//////////////////////////////////////////////////////////// 
#pragma mark - public method 



//////////////////////////////////////////////////////////// 
#pragma mark - private callback method 



@end
 
  TEMPLATE
  
  erb = ERB.new(template)
  erb.result(binding)
  
end

end
