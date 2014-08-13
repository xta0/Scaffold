-----------------------------------------------------------------------------
-- Lua2ObjC: Generate Objecive-C File
-- Author: Jayson.Xu
-- Homepage: http://www.objayc.com/blog
-- Version: 0.0.1
--
-- Overview:
-- 为TBCitySBMVC的MTOP请求部分提供代码自动化生成工具

-- REQUIREMENTS:
--   compat-5.1 if using Lua 5.0
-- 
-----------------------------------------------------------------------------

require "json"
require "string"
require "table"
require "math"

--model头文件名称
local h_name
--item头文件名称
local i_name
--request的json value
local json_req_v
--response的json value
local json_resp_v
--请求的mtop 参数
local req_mtop_v
--请求的业务参数
local req_param_v
--返回的data参数
local resp_data_v
--返回的string参数
local resp_string_v
--返回的list/dictionary参数
local resp_table_v
--model的头文件名
out_model_v = ""
--item的头文件名
out_item_v = {}


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

--是否是mtop 参数
function isMTOPParam(s)
	return (s =="API_NAME" or s =="VERSION" or s=="NEED_ECODE" or s=="NEED_SESSION")
end

--业务参数的注释
local function generatePropertyComment(o,s)
	
	assert(type(o) == 'table',"parse property error: type is not table!")
	
	  local des,req,def="","",""
	  
	  for k,v in pairs(o) do
		  if k=="required" then 
			  if v then  req = "YES" else req = "NO" end 
		  end
		 
		  if k=="description" then des = tostring(v)  end 
		  if k=="default" then def = tostring(v) end
	  end
	 
	  s = string.format("/** \n* \n* %s \n*\n* description:%s \n* required:%s \n* default:%s \n**/\n",s,des ,req,def)
	  
	  return s

end

--mtop参数的注释
local function generateMTOPComment()
	local ver,ecode,sid="","",""
	
	for k,v in pairs(req_mtop_v) do
		if k=="VERSION" then ver = v.default end
		if k=="NEED_ECODE" then 
			if v.required then ecode = "YES" else ecode = "NO" end
		end
		if k=="NEED_SESSION"then
			if v.required then sid = "YES" else sid = "NO" end
		end
	end
	
	s = string.format("/** \n* 描述:  %s \n* 版本:  %s \n* 是否需要ecode:  %s \n* 是否需要sid:  %s \n**/\n",json_req_v.description,ver ,ecode,sid)
	return s
end

--读本地的json schema
local function readJSONFile(path)
	
	assert(type(path) == 'string',"file path is not string!")
	
	local f = assert(io.open(path, "r"))
	local s = f:read "*a"
	f:close()

	result = json.decode(s)

	return result
	
end


--创建model的.h文件
local function writeModelHaderFile(path)

	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--0.write comments
	s = string.format("//\n// %s\n// iCoupon\n//\n// Created by Lua2objc.\n// Copyright (c) 2014年 Taobao.com. All rights reserved.\n//\n\n",h_name)
	assert(fwrite(f_h,s))
	
	--1."write #import"
	if countOfTable(resp_table_v) > 0 then 
		s = "#import \"TBCitySBListModel.h\"\n\n"
	else
		s = "#import \"TBCitySBModel.h\"\n\n"
	end
		
	assert(fwrite(f_h,s))
	
	--2.write comments
	s = generateMTOPComment()
	assert(fwrite(f_h,s))
	
	--3.write @interface
	if countOfTable(resp_table_v) > 0 then 
		s = string.format("@interface %s : TBCitySBListModel\n\n",h_name)
	else
		s = string.format("@interface %s : TBCitySBModel\n\n",h_name)
	end
		
	assert(fwrite(f_h,s))
	
	--4.入参 propertylist
	for k,v in pairs(req_param_v) do
		
		--注释
		s = generatePropertyComment(v,"【in】")
		fwrite(f_h,s)
		
		--@property
		s = string.format("@property(nonatomic,strong) NSString* %s; \n",k)
		fwrite(f_h,s)
		
	end
	
	--5.出参 propertylist
	for k,v in pairs(resp_string_v) do
		
		--注释
		s = generatePropertyComment(v,"【out】")
		fwrite(f_h,s)
		
		--@property
		s = string.format("@property(nonatomic,strong,readonly) NSString* %s; \n",k)
		fwrite(f_h,s)
	end

	--6.write @end
	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end

--创建model的.m文件
local function writeModelBodyFile(path)

	local f_b = assert(io.open(path,"w"),"create file handle error!")
	
	--1.write comments
	s = string.format("#import \"%s.h\"\n\n",h_name)
	assert(fwrite(f_b,s))
	
	--2,write @implement
	s = string.format("@implementation %s\n\n",h_name)
	assert(fwrite(f_b,s))
	
	--3,write "dataParams"
	s = "- (NSDictionary* )dataParams{\n"
	b = fwrite(f_b,s)

	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return nil; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
	
	--4,write "mtopParams"
	s = "- (NSDictionary* )mtopParams{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return nil; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
	
	--5,write "methodName"
	s = "- (NSString* )methodName{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return nil; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s) 

	--6,write "useAuth"
	s = "- (BOOL)useAuth{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return NO; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
	
	--7.write "useCache"
	s = "- (BOOL)useCache{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return NO; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
	
	--8,write "pageSize"
	s = "- (NSInteger)pageSize{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return 0; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
	
	--9.write "parseResponse"
	s = "- (NSArray*)parseResponse:(id)JSON error:(NSError *__autoreleasing *)error{\n"
	b = fwrite(f_b,s)
	
	s = "\n     //todo:   \n\n"
	b = fwrite(f_b,s)
	
	s = "\n\n    return nil; \n\n"
	b = fwrite(f_b,s)
	
	s = "}\n"
	b = fwrite(f_b,s)
		
	s="\n@end"
	b = fwrite(f_b,s)
	
	f_b:close()

end

--创建Item的.h文件
local function writeItemHaderFile(path)

	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--1.write comments
	s = string.format("//\n// %s\n// iCoupon\n//\n// Created by Lua2objc.\n// Copyright (c) 2014年 Taobao.com. All rights reserved.\n//\n\n",i_name)
	assert(fwrite(f_h,s))
	
	--2,write @interface
	s = "#import \"TBCitySBTableViewItem.h\"\n\n"
	assert(fwrite(f_h,s))
	s = string.format("@interface %s : TBCitySBTableViewItem\n\n",i_name)
	assert(fwrite(f_h,s))
	
	
	--3,write propertylist
	for k,v in pairs(resp_table_v) do
		
		for _k,_v in pairs(v) do
		
			--注释
			s = generatePropertyComment(_v,"【in/out】")
			fwrite(f_h,s)
		
			--@property
			if _v.type == "array" then 
				s = string.format("@property(nonatomic,strong,readwrite) NSArray* %s; \n",_k)
			elseif _v.type == "object" then
				s = string.format("@property(nonatomic,strong,readwrite) NSDictionay* %s; \n",_k)
			else
				s = string.format("@property(nonatomic,strong,readwrite) NSString* %s; \n",_k)
			end
			fwrite(f_h,s)
		end
	end
	
	--4,write @"end"
	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end

--创建Item的.m文件
local function writeItemBodyFile(path)

	local f_b = assert(io.open(path,"w"),"create file handle error!")
	
	--1.write comments
	s = string.format("#import \"%s.h\"\n\n",i_name)
	assert(fwrite(f_b,s))
	
	--2,write @implement
	s = string.format("@implementation %s\n\n",i_name)
	assert(fwrite(f_b,s))
	
	--3,override setFromDictionary
	s = "-(void) setFromDictionary:(NSDictionary* )dict {\n"
	b = fwrite(f_b,s)
	s = "\n     [super setFromDictionary:dict];\n\n\n\n"
	b = fwrite(f_b,s)
	s = "}\n"
	b = fwrite(f_b,s)
	
	s="\n@end"
	b = fwrite(f_b,s)
	
	f_b:close()

end


--///////////////////////////////////////////////////////////
--////////////main function//////////////////////////////////
--///////////////////////////////////////////////////////////


--------创建request-------------

--1,read request json file
log("read request_json_schema")
json_req_v = readJSONFile("./request.json")

printTable(json_req_v)

log("read response_json_schema")
json_resp_v = readJSONFile("./response.json")

printTable(json_resp_v)

--2,遍历request data
req_mtop_v = {}
req_param_v = {}
for k,v in pairs(json_req_v.properties) do 
	if isMTOPParam(k) then 
		req_mtop_v[k]=v 
	else
		req_param_v[k]=v
	end
end

print("--mtop参数--")
printTable(req_mtop_v)
print("--业务参数--")
printTable(req_param_v)

resp_data_v = {}
resp_string_v = {}
resp_table_v  = {}
resp_data_v = json_resp_v.properties.data.properties

print("--response--")
printTable(resp_data_v)

--3，遍历response data
for k,v in pairs(resp_data_v) do
	
	if v.type ~= "array" then resp_string_v[k]=v
	else resp_table_v[k]=v.items.properties
	end
end

print("--read-only response data")
printTable(resp_string_v)
print("--read-only response list data")
printTable(resp_table_v)

		
--3,get header file name
log("创建model")

print("请输入文件名:")
h_name = io.read()
out_model_v = h_name

--h_name = "testModel"

--4,create file
writeModelHaderFile(string.format("./%s.h",h_name))

--5,create body file
writeModelBodyFile(string.format("./%s.m",h_name))

log("创建model成功")


--------创建response-------------

--1，创建item
log("创建Item")

if countOfTable(resp_table_v) > 0 then
	
	for k,v in pairs(resp_table_v) do
	
		i_name = string.format("%s_%sItem",h_name,k)
		
		table.insert(out_item_v,i_name)
		
		writeItemHaderFile(string.format("./%s.h",i_name))
		writeItemBodyFile(string.format("./%s.m",i_name))
	
	end
end

log("创建item成功")

