
require 'fileutils'
require 'JSON'


def _err(str)
  puts "error:".red
  puts str
  exit
end

def _rb2objc(clz)
  ret = ""
  clzStr = clz.to_s
  if clzStr == "String"
    ret = "NSString"
  elsif clzStr == "Array"
    ret = "NSArray"
  elsif clzStr == "Hash"
    ret = "NSDictionary"
  elsif clzStr == "Fixnum"
    ret = "NSNumber"
  elsif clzStr == "Float"
    ret = "NSNumber"
  end

end

class Renderer

attr_accessor :hash_target, :hash_comment

def initialize(target,comment)
	@hash_target  = target
	@hash_comment = comment

	require target["tpath"] 
	require comment["tpath"] 
end

def render
	
	#check to see if @hash_target is item
	if @hash_target["namespace"] == "T_Item" || @hash_target["namespace"] == "T_ListItem"
	
		renderItem

	elsif @hash_target["namespace"] == "T_View" || @hash_target["namespace"] == "T_ListCell"
		
		renderXIB
	
	elsif @hash_target["namespace"] == "T_Comment"
		
		renderH

	else
		renderH
		renderM
	end

end

def renderH

	#if method has not been defined
	template_module = Object.const_get(@hash_target["namespace"])
	return if not template_module.respond_to? :renderH
		

	#puts @hash_target
	clz = @hash_target["class"]
	file_path = @hash_target["filepath"]
	file_path = "#{file_path}"+"#{clz}.h" if clz.to_s.length > 0

	touch file_path do

		#content
		str_content = ""

		#comment
		if clz.to_s.length > 0
			
			@hash_comment["class"] = clz
			comment_namespace = @hash_comment["namespace"]
			str_comment = Object.const_get(comment_namespace)::render(@hash_comment,"h")
			str_content += str_comment
		
		end
	

		#header file
		header_namespace = @hash_target["namespace"]
		str_header = Object.const_get(header_namespace)::renderH(@hash_target)
		str_content += str_header


	end

end

def renderM

	#if method has been defined
	template_module = Object.const_get(@hash_target["namespace"])
	return if not template_module.respond_to? :renderM

	clz = @hash_target["class"]
	file_path = @hash_target["filepath"]
	file_path = "#{file_path}"+"#{clz}.m" if clz.to_s.length > 0

	touch file_path do

		#content
		str_content = ""

		#comment
		if clz.to_s.length > 0
			
			@hash_comment["class"] = clz
			comment_namespace = @hash_comment["namespace"]
			str_comment = Object.const_get(comment_namespace)::render(@hash_comment,"m")
			str_content += str_comment
		
		end

		#body file
		header_namespace = @hash_target["namespace"]
		str_header = Object.const_get(header_namespace)::renderM(@hash_target)
		str_content += str_header

		end

end

def touch(path,&block)

	File.delete(path) if File.exist?path
	File.open(path, "w") { |file|  

		if block_given?
			file.puts block.call
		else
			puts "missing block"
		end
	}
end

def renderXIB

	xib_path = @hash_target["xpath"]

	if xib_path.to_s.length > 0

		
	end

	renderH
	renderM

end

def renderItem

	response_path = @hash_target["response"]

	if response_path.to_s.length > 0
	_err "response json does not exist !!" if not File.exist?response_path

		##read response
		puts "Parsing Repsonse: #{response_path}"
		response_json = nil
		begin
		
		f = File.read(response_path)
		
			response_json = JSON.parse(f)

		rescue
		
		  puts "parse response json file error"
		
		end

		propertylist = []
		response_json.each{|k,v|

		 	property = Hash.new
		 	property["name"] = k
		 	property["class"] = _rb2objc(v.class)
		 	propertylist.push property

		}
		#add properties to item
		@hash_target["property"] = propertylist

	end

	renderH
	renderM

end

end
