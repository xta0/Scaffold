-----------------------------------------------------------------------------
-- Lua2ObjC: Generate an Objecive-C file
-- Author: Tao Xu
-- Homepage: http://www.objayc.com/blog
-- Version: 0.0.1
--
-- USAGE:
-- todo
--
-- REQUIREMENTS:
--   compat-5.1 if using Lua 5.0
--
-----------------------------------------------------------------------------

require "json"
require "string"
require "table"
require "math"


--头文件名称
local h_name
--decode后的json value
local json_v


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

function isLuaType(o)
  local t = type(o)
  return (t=='string' or t=='boolean' or t=='number' or t=='nil' or t=='table') or (t=='function' and o==null) 
end



local function checkList(t)
	
	--1,check type
	assert( typeof(t) == "table" , "param t is not a table!")
	
	--2,check list
	for k,v in pairs(t) do
		--count = 0
		if typeof(v) == "table" then
			if isArray(v) then
				subJsonList[k] = "list"
			else
				subJsonList[k] = "dictionary"
			end
		end
	end
	
	return ret
end

local function readJSONFile(path)
	
	assert(type(path) == 'string',"file path is not string!")
	
	local f = assert(io.open(path, "r"))
	local s = f:read "*a"
	f:close()

	result = json.decode(s)

	return result
	
end


--创建.h文件
local function writeHaderFile(path)

	local f_h = assert(io.open(path,"w"),"create file handle error!")
	
	--1.write comments
	assert(fwrite(f_h,"// created by lua2objc \n\n"))
	
	--2,write @interface
	s = "#import \"TBCitySBTableViewItem.h\"\n\n"
	assert(fwrite(f_h,s))
	s = string.format("@interface %s : TBCitySBTableViewItem\n\n",h_name)
	assert(fwrite(f_h,s))
	
	--3,write propertylist
	for k,v in pairs(json_v) do
		
		if typeof(v) == "table" then
			
			if isArray(v) then
				s = string.format("@property(nonatomic,strong) NSArray* %s; \n",k)
			else
				s = string.format("@property(nonatomic,strong) NSDictionary* %s; \n",k)
			end
		
		else
			s = string.format("@property(nonatomic,strong) NSString* %s; \n",k)
		end
		
		fwrite(f_h,s)
		
	end

	s="\n@end"
	b = fwrite(f_h,s)
	
	f_h:close()
	
end

--创建.m文件
local function writeBodyFile(path)

	local f_b = assert(io.open(path,"w"),"create file handle error!")
	
	--1.write comments
	s = string.format("#import \"%s.h\"\n\n",h_name)
	assert(fwrite(f_b,s))
	
	--2,write @implement
	s = string.format("@implementation %s\n\n",h_name)
	assert(fwrite(f_b,s))
	
	--3,override setFromDictionary
	s = "-(void) autoKVCBinding:(NSDictionary* )dict {\n"
	b = fwrite(f_b,s)
	s = "\n     [super autoKVCBinding:dict];\n\n\n\n"
	b = fwrite(f_b,s)
	s = "}\n"
	b = fwrite(f_b,s)
	
	s="\n@end"
	b = fwrite(f_b,s)
	
	f_b:close()

end

---------------------

--1,read json file
json_v = readJSONFile("./input.json")

--2,get header file name
print("请输入文件名:")
h_name = io.read()

--3,create file
writeHaderFile(string.format("./%s.h",h_name))

--4,create body file
writeBodyFile(string.format("./%s.m",h_name))

log("success")




