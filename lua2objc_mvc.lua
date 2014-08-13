-----------------------------------------------------------------------------
-- Lua2ObjC: Generate Objecive-C File
-- Author: Jayson.Xu
-- Homepage: http://www.objayc.com/blog
-- Version: 0.0.1
--
-- Overview:
-- 为TBCitySBMVC提供代码自动化生成工具

-- REQUIREMENTS:
--   compat-5.1 if using Lua 5.0
-- 
-----------------------------------------------------------------------------

--controller头文件名称
local c_name

--datasource头文件名称
local ds_name

--delegate头文件名称
local dl_name

--controller父类class
local p_name



--log
local function log(fmt,...)
print("////////////////////////////////////////")
print("//",string.format(fmt,...))
print("////////////////////////////////////////\n")
end

--write file
function fwrite(f,fmt,...)
	return assert( f:write(string.format(fmt,...)))
end

--获取object类型
local function typeof(o)
	return tostring(type(o))
end

--获取table的count
local function countOfTable(o)
	local count = 0
	for i,v in pairs(o)
	do
		count = count + 1
	end
	
	return count 
end

--打印出table的key，value
local function printTable(o)
	for k,v in pairs(o)
	do print(k,v)
	end
	print("\n")
end

--检测table是否是array
function isArray(t)

  local maxIndex = 0
  for k,v in pairs(t) do
    if (type(k)=='number' and math.floor(k)==k and 1<=k) then	
      if (not isLuaType(v)) then return false end	
      maxIndex = math.max(maxIndex,k)
    else
      if (k=='n') then
        if v ~= table.getn(t) then return false end 
      else 
        if isLuaType(v) then return false end
      end  -- End of (k~='n')
    end -- End of k,v not an indexed pair
  end  -- End of loop
  return true, maxIndex
end

--lua数据结构类型
function isLuaType(o)
  local t = type(o)
  return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or (t=='function' and o==null) 
end


function generateHeaderComment(name,s)
	
	return string.format("//\n// %s%s\n// iCoupon\n//\n// Created by Lua2objc.\n// Copyright (c) 2014年 Taobao.com. All rights reserved.\n//\n\n",name,s)

end

--创建controller
local function writeControllerHaderFile(path,p)
		
	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--注释
	s = generateHeaderComment(c_name,".h")
	assert(fwrite(f_h,s))
	
	--@import
	s = string.format("#import \"%s.h\"\n\n",p)
	assert(fwrite(f_h,s))
	
	--@interface
	s = string.format("@interface %s : %s\n\n",c_name,p)
	assert(fwrite(f_h,s))
	
	--@end
	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end


local function writeControllerBodyFile(path,p)

	--判断是否是tableviewcontrolelr
	local b = false
	
	if p == "TBCitySBViewController" then
		b = false
	else
		b = true
	end
		

	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--注释
	s = generateHeaderComment(c_name,".m")
	assert(fwrite(f_h,s))
	
	--@import
	s = string.format("#import \"%s.h\"\n",c_name)
	assert(fwrite(f_h,s))
	
	s = "#import \"TBCitySBModel.h\"\n\n"
	assert(fwrite(f_h,s))
	
	--import datasource & delegate
	if b then
		s = string.format("#import \"%s.h\"\n",ds_name)
		assert(fwrite(f_h,s))
		
		s = string.format("#import \"%s.h\"\n\n",dl_name)
		assert(fwrite(f_h,s))
	end
	
	--@interface
	s = string.format("@interface %s ()\n\n",c_name)
	assert(fwrite(f_h,s))
	
	if b then
		s = string.format("@property(nonatomic,strong) %s* ds;\n",ds_name)
		assert(fwrite(f_h,s))
		
		s = string.format("@property(nonatomic,strong) %s* dl;\n",dl_name)
		assert(fwrite(f_h,s))	
	end
	
	--@end
	s="\n@end\n\n"
	assert(fwrite(f_h,s))
	
	--@implementation
	s = string.format("@implementation %s\n\n",c_name)
	assert(fwrite(f_h,s))
	
	--@setter
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - setters \n\n\n\n"
	assert(fwrite(f_h,s))
	
	--@getter
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - getters \n\n\n\n"
	assert(fwrite(f_h,s))
	
	if b then
		s = string.format("- (%s* )ds{\n\n  if (!_ds) {\n      _ds = [%s new];\n   }\n   return _ds;\n}\n\n",ds_name,ds_name)
		assert(fwrite(f_h,s))
		
		s = string.format("- (%s* )dl{\n\n  if (!_dl) {\n      _dl = [%s new];\n   }\n   return _dl;\n}\n\n",dl_name,dl_name)
		assert(fwrite(f_h,s))
	end
	
	--@life cycle
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - life cycle \n\n"
	assert(fwrite(f_h,s))
	
	--@loadview
	s = "- (void)loadView{ \n\n    [super loadView]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@viewdidload
	s = "- (void)viewDidLoad{ \n\n    [super viewDidLoad]; \n\n"
	assert(fwrite(f_h,s))
	
	if b then
		
		s = "    //1,config your tableview\n"
		assert(fwrite(f_h,s)) 
		
		s = "    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);\n"
		assert(fwrite(f_h,s)) 
		
		s = "    self.tableView.backgroundColor = [UIColor clearColor];\n"
		assert(fwrite(f_h,s)) 
		
		s = "    self.tableView.showsVerticalScrollIndicator = YES;\n\n"
		assert(fwrite(f_h,s)) 
		
		s = "    //2,set some properties:下拉刷新，自动翻页\n"
		assert(fwrite(f_h,s)) 
		
		s = "    self.bNeedLoadMore = YES;\n    self.bNeedPullRefresh = YES;\n\n"
		assert(fwrite(f_h,s)) 
		
		s = "    //3，bind your delegate and datasource to tableview\n"
		assert(fwrite(f_h,s)) 
		
		s = "    self.dataSource = self.ds;\n    self.delegate = self.dl;\n\n"
		assert(fwrite(f_h,s)) 
		
		s = "    //4,@REQUIRED:YOU MUST SET A KEY MODEL!\n    //self.keyModel = self.model;\n\n"
		assert(fwrite(f_h,s)) 
		
		s = "    //5,REQUIRED:register model to parent view controller\n    //[self registerModel:self.model];\n\n"
		assert(fwrite(f_h,s)) 
		
		s = "    //6,load model\n"
		assert(fwrite(f_h,s)) 
		
		s = "    [self load];\n"
		assert(fwrite(f_h,s)) 
		
	end
	
	s = "\n}\n\n" --end of view did load
	assert(fwrite(f_h,s)) 
	
	--@memory warning
	s = "- (void)didReceiveMemoryWarning{ \n\n    [super didReceiveMemoryWarning]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@dealloc
	s = "- (void)dealloc{ \n\n}\n\n"
	assert(fwrite(f_h,s))
	
	
	if b then 
	
	--@TBCitySBTableViewController
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - TBCitySBViewController \n\n\n\n"
	assert(fwrite(f_h,s))
	
	--@didselect
	s = "- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{\n\n  //todo:... \n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@didselect_with_component
	s = "- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath component:(NSDictionary *)bundle{\n\n  //todo:... \n\n}\n\n"
	assert(fwrite(f_h,s))
		
	else
		
	--@TBCitySBViewController
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - TBCitySBViewController \n\n\n\n"
	assert(fwrite(f_h,s))
	
	--@showEmpty
	s = "- (void)showEmpty:(TBCitySBModel *)model{ \n\n    [super showEmpty:model]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@showLoading
	s = "- (void)showLoading:(TBCitySBModel *)model{ \n\n    [super showLoading:model]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@showModel
	s = "- (void)showModel:(TBCitySBModel *)model{ \n\n    [super showModel:model]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@showError
	s = "- (void)showError:(TBCitySBModel *)model{ \n\n    [super showError:model]; \n\n\n\n}\n\n"
	assert(fwrite(f_h,s))
	
	end
	
	--@public method
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - public method \n\n\n\n"
	assert(fwrite(f_h,s))
	

	--@private callback method
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - private callback method \n\n\n\n"
	assert(fwrite(f_h,s))
	
	
	--@private method
	s = "//////////////////////////////////////////////////////////// \n#pragma mark - private method \n\n\n\n"
	assert(fwrite(f_h,s))
	

	--@end
	s="\n@end"
	assert(fwrite(f_h,s))
	
	f_h:close()
	
end

local function writeDataSourceHeaderFile(path)
	
	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--注释
	s = generateHeaderComment(ds_name,".h")
	assert(fwrite(f_h,s))
	
	--@import
	p = "TBCitySBTableViewDataSource"
	s = string.format("#import \"%s.h\"\n\n",p)
	assert(fwrite(f_h,s))
	
	--@interface
	s = string.format("@interface %s : %s\n\n",ds_name,p)
	assert(fwrite(f_h,s))
	
	--@end
	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end

local function writeDataSourceBodyFile(path)
	
	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--注释
	s = generateHeaderComment(ds_name,".m")
	assert(fwrite(f_h,s))
	
	--@import
	s = string.format("#import \"%s.h\"\n",ds_name)
	assert(fwrite(f_h,s))
	
	s = string.format("#import \"TBCitySBTableViewCell.h\"\n\n")
	assert(fwrite(f_h,s))
	
	--@interface
	s = string.format("@interface %s ()\n\n",ds_name)
	assert(fwrite(f_h,s))
	
	--@end
	s="\n@end\n\n"
	assert(fwrite(f_h,s))
	
	--@implementation
	s = string.format("@implementation %s\n\n",ds_name)
	assert(fwrite(f_h,s))
	
	--@number of section
	s = "- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{\n\n    //default:\n    return 1; \n\n}\n\n"
	assert(fwrite(f_h,s))
	
	--@cell for class
	s = "- (Class)cellClassForItem:(id)item AtIndex:(NSIndexPath *)indexPath{\n\n    //@REQUIRED:\n    return [TBCitySBTableViewCell class]; \n\n}\n\n"
	assert(fwrite(f_h,s))
	
	
	--@item for cell
	s = "//@optional:\n"
	assert(fwrite(f_h,s))
	
	s = "//- (TBCitySBTableViewItem*)itemForCellAtIndexPath:(NSIndexPath*)indexPath{\n\n    //default:\n    //return [super itemForCellAtIndexPath:indexPath]; \n\n//}\n\n"
	assert(fwrite(f_h,s))
	
	--@end
	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end

local function writeDelegateHaderFile(path)
	
	local f_h = assert(io.open(path,"w"),"create file handle error!")

	--注释
	s = generateHeaderComment(dl_name,".h")
	assert(fwrite(f_h,s))

	--@import
	p = "TBCitySBTableViewDelegate"
	s = string.format("#import \"%s.h\"\n\n",p)
	assert(fwrite(f_h,s))

	--@interface
	s = string.format("@interface %s : %s\n\n",dl_name,p)
	assert(fwrite(f_h,s))

	--@end
	s="\n@end"
	b = fwrite(f_h,s)

	f_h:close()
end

local function writeDelegateBodyFile(path)

	local f_h = assert(io.open(path,"w"),"create file handle error!")

	--注释
	s = generateHeaderComment(dl_name,".m")
	assert(fwrite(f_h,s))

	--@import
	s = string.format("#import \"%s.h\"\n\n",dl_name)
	assert(fwrite(f_h,s))

	--@interface
	s = string.format("@interface %s ()\n\n",dl_name)
	assert(fwrite(f_h,s))

	--@end
	s="\n@end\n\n"
	assert(fwrite(f_h,s))

	--@implementation
	s = string.format("@implementation %s\n\n",dl_name)
	assert(fwrite(f_h,s))
	
	--@end
	s="\n@end"
	b = fwrite(f_h,s)

	f_h:close()

end

--///////////////////////////////////////////////////////////
--////////////main function//////////////////////////////////
--///////////////////////////////////////////////////////////

--dofile("./lua2objc_json_schema.lua")

--print("*****",out_model_v,"******")
--print("*****",out_item_v, "******")


print("请输入Controller名称,按回车确定：")

c_name = io.read()

print("\n请选择继承对象,按回车确定：")
print("1：TBCitySBViewController")
print("2：TBCitySBTableViewController")

repeat
s = io.read()

if s=="1" then
	 p_name = "TBCitySBViewController" 
elseif s =="2" then
	 p_name = "TBCitySBTableViewController"
else 
	print("请选择继承对象,按回车确定：")
	print("1：TBCitySBViewController")
	print("2：TBCitySBTableViewController")

end
	
until (s == "1" or s == "2")


if s == "1" then 
	p_name = "TBCitySBViewController"
else
	p_name = "TBCitySBTableViewController"
end
	
	
if s == "2" then
	
	--创建datasource & delegate
	local lower_c_name = string.lower(c_name)
	local prefix_c_name = ""
	
	
	if string.find(lower_c_name,"viewcontroller") then
		
	    i,j = string.find(lower_c_name,"viewcontroller")
		prefix_c_name = string.sub(c_name,1,i-1)
			
	elseif string.find(lower_c_name,"controller") then 
		
		i,j = string.find(lower_c_name,"controller")
		prefix_c_name = string.sub(c_name,1,i-1)

	else
		prefix_c_name = c_name
	
	end
			
	ds_name = string.format("%sDataSource",prefix_c_name)
	dl_name = string.format("%sDelegate",prefix_c_name)
	
	log("创建DataSource")
	writeDataSourceHeaderFile(string.format("./%s.h",ds_name))
	writeDataSourceBodyFile(string.format("./%s.m",ds_name))
	log("Success!")
	
	log("创建Delegate")
	writeDelegateHaderFile(string.format("./%s.h",dl_name))
	writeDelegateBodyFile(string.format("./%s.m",dl_name))
	log("Success!")
	

end

--创建controller
log("创建controller")

writeControllerHaderFile(string.format("./%s.h",c_name),p_name)
writeControllerBodyFile(string.format("./%s.m",c_name),p_name)

log("Success!")







