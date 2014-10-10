#encoding:utf-8

require 'json'
require 'fileutils'
require 'yaml'
require './core/package.rb'
require './core/class.rb'



class Factory

	def self.createPackage(args)

		maker = PackageMaker.new(args)
		ret = nil

		type = args[:package_type]

		if type == "default"

			ret =  maker.createDefaultPackage
		end

		if type == "list"

			ret = maker.createListPackage
			
		end

		if type == "collection"

			ret = maker.createCollectionPackage
			
		end

		return ret

	end


	def self.createClass(args)

		ret = {}
		
		superclass 		= args[:superclass]
		classname  		= args[:class_name]
		optional_path 	= args[:optional_class_path]

		params = {:type => "c", :class => classname, :superclass => superclass, :optional_path => optional_path}

		rbclass = nil

		puts $template

		$template.each{|k,v|

			if v.kind_of?(Hash)

				objc_class = v[:class]

				if objc_class == superclass

					rbclass = v[:rbclass]

					break
				end
				
			end
		
		}

		if rbclass.to_s.length > 0

			obj = Object.const_get(rbclass).new(params)
			obj.create()
			ret[classname] = obj.toHash()
			puts "Hash:#{ret}"
		else
			puts "Can not find superclass in template"

		end

		return ret

	end


end

