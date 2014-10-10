#encoding:utf-8

require 'optparse'

class CommandLineParse

  def self.parse(args)

	options = {}
	option_parser = OptionParser.new do |opts|

		#create MVC Package
		opts.on( "-p Package name, Package type, Optional package config file Path",Array) do |list|
			
			options[:type] = "package"
		 	options[:package_name] = list[0]

		 	if list.count == 1 
		 			
		 		options[:package_type] = "default"
		 		options[:optional_package_path] = nil

		 	elsif list.count == 2
		 		
		 		arg1_l = list[1].split(':')[0]
		 		arg1_r = list[1].split(':')[1]
		 		
		 		if arg1_l == "type"

		 			options[:package_type] =  arg1_r
		 			options[:optional_package_path] = nil;

		 		elsif arg1_l == "path"
		 			
		 			options[:package_type] = "default"
		 			options[:optional_package_path] = arg1_r

		 		end

		 	else

		 		arg1_l = list[1].split(':')[0]
		 		arg1_r = list[1].split(':')[1]

		 		arg2_l = list[2].split(':')[0]
		 		arg2_r = list[2].split(':')[1]

		 		if arg1_l == "type" || arg1_l == "path"
		 			options[:package_type] =  arg1_r if arg1_l == "type"
		 			options[:optional_package_path] =  arg1_r if arg1_l == "path"
 		 		end

		 		if arg2_l == "path" || arg2_l == "type"
		 			options[:package_file] = arg2_r if arg2_l == "path"
		 			options[:optional_package_path] = arg2_r if arg2_l == "type"
		 		end

		 	end

		end

		#create single class files
		opts.on( "-c ClassName,SuperClass,Path",Array) do |list|

			options[:type] = "class"

			arg1 = list[0].split(':')[0]
	 		arg2 = list[0].split(':')[1]
	 		
	 		options[:class_name] = arg1
	 		options[:superclass] = arg2
	 		options[:optional_class_path] = list[1]

		end

	  opts.on_tail("-h", "--help") do
        puts opts
        exit
      end


	end #end of OptionParser.new

	option_parser.parse!(ARGV)
	options

   end #end of parse

end #end of CommandLineParse

# options = CommandLineParse.parse(ARGV)
# puts options.inspect
# puts ARGV.inspect



