#encoding:utf-8


class BaseClass

	attr_accessor :args, :objc_class, :objc_superclass, :tpath, :tnamespace, :filepath, :name ,:type ,:package_name

	def initialize(args)

		self.args					= args
		self.type 					= args[:type] #
		self.package_name 			= args[:package_name]

		self.objc_class 			= args[:class]
		self.objc_superclass 		= args[:superclass]

	end

	def create
	end

	def toHash
	end

end



class ConfigHeader < BaseClass

	def create
		
		self.objc_class 	= "#{$clz_prefix}#{self.package_name}Config" if self.type == "p"
		
		self.filepath  		= "./#{self.package_name}/config/" if self.type == "p"
		self.filepath       = "./" if self.type == "c"


		self.tpath 			= "./template/#{$sdk_name.downcase}/template_#{$template[:config][:template]}.rb"
		self.tnamespace    	= "#{$template[:config][:namespace]}"

		
	end

	def toHash

		config_hash 						= Hash.new
		config_hash["class"]				= self.objc_class
		config_hash["proj"] 				= $proj_name
		config_hash["package_name"] 		= self.package_name
		config_hash["tpath"]				= self.tpath
		config_hash["namespace"]			= self.tnamespace
		config_hash["filepath"]				= self.filepath
		config_hash

	end
end

class ViewController < BaseClass

	attr_accessor :model
	def create

		self.objc_class  				= self.type == "p" ? "#{$clz_prefix}#{self.package_name}ViewController" : self.objc_class
		self.objc_superclass 			= self.type == "p" ? "#{$template[:viewcontroller][:class]}" : self.objc_superclass
		self.filepath 					= self.type == "p" ? "./#{self.package_name}/controller/" : "./"
		self.tpath 						= "./template/#{$sdk_name.downcase}/template_#{$template[:viewcontroller][:template]}.rb"
		self.tnamespace 				= "#{$template[:viewcontroller][:namespace]}"
	
	end

	def toHash

		controller_hash 				= {}
		controller_hash["class"] 		= self.objc_class
		controller_hash["superclass"] 	= self.objc_superclass
		controller_hash["model"] 		= [{"name"=>self.model.name,"class"=>self.model.objc_class,"superclass"=>self.model.objc_superclass}] if self.model
		controller_hash["tpath"] 		= self.tpath
		controller_hash["namespace"] 	= self.tnamespace
		controller_hash["filepath"] 	= self.filepath
		controller_hash

	end

end

class ListViewController < BaseClass

	attr_accessor :model
	attr_accessor :ds
	attr_accessor :dl


	def create

		self.objc_class  		= self.type == "p" ? "#{$clz_prefix}#{self.package_name}ListViewController" : self.objc_class
		self.objc_superclass 	= self.type == "p" ? "#{$template[:listviewcontroller][:class]}" : self.objc_superclass
		self.filepath 		    = self.type == "p" ? "./#{self.package_name}/controller/" : "./"

		self.tpath 				= "./template/#{$sdk_name.downcase}/template_#{$template[:listviewcontroller][:template]}.rb"
		self.tnamespace 		= "#{$template[:listviewcontroller][:namespace]}"

	end


	def toHash

	
		controller_hash 				= {}
		controller_hash["class"] 		= self.objc_class
		controller_hash["superclass"] 	= self.objc_superclass
		controller_hash["model"] 		= [{"name"=>self.model.name,"class"=>self.model.objc_class,"superclass"=>self.model.objc_superclass}] if self.model
		controller_hash["datasource"] 	= {"name"=>self.ds.name,"class"=>self.ds.objc_class,"superclass" => self.ds.objc_superclass} if self.ds
		controller_hash["delegate"] 	= {"name"=>self.dl.name,"class"=>self.dl.objc_class,"superclass" => self.dl.objc_superclass} if self.dl
		controller_hash["tpath"] 		= self.tpath
		controller_hash["namespace"] 	= self.tnamespace
		controller_hash["filepath"] 	= self.filepath
		controller_hash

	end

end

class Model < BaseClass

	def create
	
		self.objc_class 		= self.type == "p" ? "#{$clz_prefix}#{self.package_name}Model" : self.objc_class
		self.objc_superclass 	= self.type == "p" ? "#{$template[:model][:class]}" : self.objc_superclass
		self.filepath 			= self.type == "p" ? "./#{self.package_name}/model/" : "./"
		self.name 				= self.type == "p" ? "#{self.package_name[0].downcase + self.package_name[1..-1]}Model" : ""
		self.tpath 				= "./template/#{$sdk_name.downcase}/template_#{$template[:model][:template]}.rb"
		self.tnamespace 		= "#{$template[:model][:namespace]}"
		

	end
	
	def toHash

		
		model_hash 					= Hash.new
		model_hash["class"] 		= self.objc_class
		model_hash["superclass"] 	= self.objc_superclass
		model_hash["api"] 			= ""
		model_hash["tpath"] 		= self.tpath
		model_hash["namespace"] 	= self.tnamespace
		model_hash["filepath"] 		= self.filepath
		model_hash
	end 

end

class ModelTest < BaseClass

	attr_accessor :sdkheader, :model

	def create

		self.objc_class 		= self.type == "p" ? "#{self.model.objc_class}Test" : self.objc_class
		self.objc_superclass 	= self.type == "p" ? "#{$template[:modeltest][:class]}" : self.objc_superclass
		self.filepath       	= self.type == "p" ? "./#{self.package_name}/test/" : "./"

		self.sdkheader 			= "#{$template[:modeltest][:sdkheader]}"
		self.tpath 				= "./template/#{$sdk_name.downcase}/template_#{$template[:modeltest][:template]}.rb"
		self.tnamespace 		= "#{$template[:modeltest][:namespace]}"

	end

	def toHash

		model_test_hash = {}
		model_test_hash["class"] 			= self.objc_class
		model_test_hash["superclass"] 		= self.objc_superclass
		model_test_hash["modelclass"] 		= self.model.objc_class
		model_test_hash["modelsuperclass"]  = self.model.objc_superclass
		model_test_hash["sdkheader"] 		= self.sdkheader
		model_test_hash["tpath"] 			= self.tpath
		model_test_hash["namespace"] 		= self.tnamespace
		model_test_hash["filepath"] 		= self.filepath
		model_test_hash

	end

end


class ListModel < BaseClass

	def create 

		self.objc_class 			= self.type == "p" ? "#{$clz_prefix}#{self.package_name}ListModel" : self.objc_class
		self.objc_superclass 		= self.type == "p" ? "#{$template[:listmodel][:class]}" : self.objc_superclass
		self.filepath 				= self.type == "p" ? "./#{self.package_name}/model/" : "./"
		self.name 					= self.type == "p" ? "#{self.package_name[0].downcase + self.package_name[1..-1] }ListModel" : ""
		self.tpath 					= "./template/#{$sdk_name.downcase}/template_#{$template[:listmodel][:template]}.rb"
		self.tnamespace 			= "#{$template[:listmodel][:namespace]}"
		
	end

	def toHash

		model_hash 					= Hash.new
		model_hash["class"] 		= self.objc_class
		model_hash["superclass"] 	= self.objc_superclass
		model_hash["api"] 			= ""
		model_hash["tpath"] 		= self.tpath
		model_hash["namespace"] 	= self.tnamespace
		model_hash["filepath"] 		= self.filepath
		model_hash

	end

end

class Item < BaseClass

	attr_accessor :response_json

	def initialize(args)

		super(args)
		self.response_json = args[:optional_path]

	end

	def create

		self.objc_class 		= self.type == "p" ? "#{$clz_prefix}#{self.package_name}Item" : self.objc_class
		self.objc_superclass 	= self.type == "p" ? "#{$template[:item][:class]}" : self.objc_superclass
		self.filepath 			= self.type == "p" ? "./#{self.package_name}/item/" : "./"
		
		self.tpath 			= "./template/#{$sdk_name.downcase}/template_#{$template[:item][:template]}.rb"
		self.tnamespace 	= "#{$template[:item][:namespace]}"

	end

	def toHash

	
		item_hash 				= Hash.new
		item_hash["class"] 		= self.objc_class
		item_hash["superclass"] = self.objc_superclass
		item_hash["response"] 	= self.response_json
		item_hash["tpath"] 		= self.tpath
		item_hash["namespace"] 	= self.tnamespace
		item_hash["filepath"] 	= self.filepath
		item_hash

	end

end



class ListItem < BaseClass

	attr_accessor :response_json


	def initialize(args)

		super(args)
		self.response_json = args[:optional_path]

	end

	def create
	
		self.objc_class 	 = self.type == "p" ?  "#{$clz_prefix}#{self.package_name}ListItem" : self.objc_class
		self.objc_superclass = self.type == "p" ?  "#{$template[:listitem][:class]}" : self.objc_superclass
		self.filepath 		 = self.type == "p" ?  "./#{self.package_name}/item/" : "./"

		self.tpath 		= "./template/#{$sdk_name.downcase}/template_#{$template[:listitem][:template]}.rb"
		self.tnamespace 	= "#{$template[:listitem][:namespace]}"
	end


	def toHash


		item_hash  				= Hash.new
		item_hash["class"] 		= self.objc_class
		item_hash["superclass"] = self.objc_superclass
		item_hash["response"] 	= self.response_json
		item_hash["tpath"] 		= self.tpath
		item_hash["namespace"] 	= self.tnamespace
		item_hash["filepath"] 	= self.filepath
		item_hash


	end

end

class View < BaseClass

	attr_accessor :xib_path, :item

	def initialize(args)

		super(args)
		self.xib_path = args[:optional_path]

	end

	def create

		self.objc_class			= self.type == "p" ? "#{$clz_prefix}#{self.package_name}SubView" : self.objc_class
		self.objc_superclass	= self.type == "p" ? "#{$template[:view][:class]}" : self.objc_superclass
		self.filepath 			= self.type == "p" ? "./#{self.package_name}/view/" : "./"

		self.tpath			= "./template/#{$sdk_name.downcase}/template_#{$template[:view][:template]}.rb"
		self.tnamespace      = "#{$template[:view][:namespace]}"
		self.name			= ""

	end

	def toHash


		view_hash 				= Hash.new
		view_hash["class"]		= self.objc_class
		view_hash["superclass"] = self.objc_superclass
		view_hash["tpath"]		= self.tpath
		view_hash["xpath"] 		= self.xib_path
		view_hash["filepath"] 	= self.filepath
		view_hash["namespace"]  = self.tnamespace
		view_hash["itemclass"]  = self.item.objc_class if self.item
		view_hash

	end


end


class ListDataSource < BaseClass

	attr_accessor :cell

	def create

		self.objc_class 		 = self.type == "p" ? "#{$clz_prefix}#{self.package_name}ListViewDataSource" : self.objc_class
		self.objc_superclass 	 = self.type == "p" ? "#{$template[:listviewdatasource][:class]}" : self.objc_superclass
		self.filepath 		     = self.type == "p" ? "./#{self.package_name}/datasource/" : "./"

		self.name 			= "ds"
		self.tpath 			= "./template/#{$sdk_name.downcase}/template_#{$template[:listviewdatasource][:template]}.rb"
		self.tnamespace 		= "#{$template[:listviewdatasource][:namespace]}"
		

	end

	def toHash

		datasource_hash = {}
		datasource_hash["class"] 		= self.objc_class
		datasource_hash["superclass"] 	= self.objc_superclass
		datasource_hash["cellclass"] 	= self.cell.objc_class if self.cell
		datasource_hash["tpath"] 		= self.tpath
		datasource_hash["namespace"] 	= self.tnamespace
		datasource_hash["filepath"] 	= self.filepath
		datasource_hash

	end
end

class ListDelegate < BaseClass


	def create

		self.objc_class 		= self.type == "p" ? "#{$clz_prefix}#{self.package_name}ListViewDelegate" : self.objc_class
		self.objc_superclass 	= self.type == "p" ? "#{$template[:listviewdelegate][:class]}" : self.objc_superclass
		self.filepath 			= self.type == "p" ? "./#{self.package_name}/delegate/" : "./"


		self.name 			= "dl"
		self.tpath 			= "./template/#{$sdk_name.downcase}/template_#{$template[:listviewdelegate][:template]}.rb"
		self.tnamespace 		= "#{$template[:listviewdelegate][:namespace]}"
	
	end

	def toHash

		delegate_hash = {}
		delegate_hash["class"] 			= self.objc_class
		delegate_hash["superclass"] 	= self.objc_superclass
		delegate_hash["tpath"] 			= self.tpath
		delegate_hash["namespace"] 		= self.tnamespace
		delegate_hash["filepath"] 		= self.filepath
		delegate_hash

	end

end

class ListCell < BaseClass

	attr_accessor :item

	def create

		self.objc_class 			= self.type == "p" ? "#{$clz_prefix}#{self.package_name}ListCell" : self.objc_class
		self.objc_superclass 	 	= self.type == "p" ? "#{$template[:cell][:class]}" : self.objc_superclass
		self.filepath 				= self.type == "p" ? "./#{self.package_name}/cell/" : "./"

		self.tpath 			=  "./template/#{$sdk_name.downcase}/template_#{$template[:cell][:template]}.rb"
		self.tnamespace 	=  "#{$template[:cell][:namespace]}"
		
	end

	def toHash

		cell_hash 				= Hash.new
		cell_hash["class"] 		= self.objc_class
		cell_hash["superclass"] = self.objc_superclass
		cell_hash["itemclass"] 	= self.item.objc_class if self.item
		cell_hash["height"] 	= "44"
		cell_hash["tpath"] 		= self.tpath
		cell_hash["namespace"] 	= self.tnamespace
		cell_hash["filepath"] 	= self.filepath
		cell_hash

	end

end








