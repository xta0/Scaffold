#encoding:utf-8

require './core/class.rb'


def _err(str)
  puts "error:"
  puts str
  exit
end

def _log(str)
  puts "...................................................\n"
  puts str
end



class PackageMaker

	attr_accessor :classList
	attr_accessor :package_name


	def config
	
		_log("Create Directory")
		FileUtils.mkdir_p ["#{self.package_name}/controller", "#{self.package_name}/model", "#{self.package_name}/view","#{self.package_name}/item"]
		FileUtils.mkdir_p ["#{self.package_name}/resource","#{self.package_name}/config","#{self.package_name}/test"]

	end

	def initialize(args)

		#get package_name
		@package_name = args[:package_name]

		#create folders
		self.config()

	end
	
	def createDefaultPackage

		args = {:type => "p",:package_name => self.package_name}
		##create config Hash
		config 		= ConfigHeader.new(args)
		config.create()

		##create model hash
		model 		= Model.new(args)
		model.create()

		modelTest   = ModelTest.new(args)
		modelTest.model = model
		modelTest.create()


		##create view controller
		controller 		 = ViewController.new(args)
		controller.model = model
		controller.create()

		#create item
		item = Item.new(args)
		item.create()

		#create view
		view = View.new(args)
		view.item = item
		view.create()

		meta_hash = {}
		##create controller hash
		meta_hash["controller"] 		= [].push controller.toHash
		meta_hash["model"] 				= [].push model.toHash
		meta_hash["modeltest"]			= [].push modelTest.toHash
		meta_hash["item"]				= [].push item.toHash
		meta_hash["view"]				= [].push view.toHash
		meta_hash["config"]				= config.toHash

		meta_hash

	end


	def createListPackage

		FileUtils.mkdir_p ["#{self.package_name}/datasource", "#{self.package_name}/delegate", "#{self.package_name}/cell"]	

		args = {:type => "p",:package_name => self.package_name}

		##create config Hash
		config = ConfigHeader.new(args)
		config.create()

		##create model hash
		listModel 		= ListModel.new(args)
		listModel.create()

		listModelTest   = ModelTest.new(args)
		listModelTest.model = listModel
		listModelTest.create()
 

		#create item
		listItem = ListItem.new(args)
		listItem.create()

		#create cell
		listCell  =ListCell.new(args)
		listCell.item = listItem
		listCell.create()

		#create datasource
		ds = ListDataSource.new(args)
		ds.cell = listCell
		ds.create()

		#create delegate
		dl = ListDelegate.new(args)
		dl.create()

		##create view controller
		listController = ListViewController.new(args)
		listController.model = listModel
		listController.ds = ds
		listController.dl = dl
		listController.create()


		meta_hash = {}
		##create controller hash
		meta_hash["controller"] 		= [].push listController.toHash
		meta_hash["model"] 				= [].push listModel.toHash
		meta_hash["modeltest"]			= [].push listModelTest.toHash
		meta_hash["item"]				= [].push listItem.toHash
		meta_hash["cell"]				= [].push listCell.toHash
		meta_hash["datasource"]			= [].push ds.toHash
		meta_hash["delegate"]			= [].push dl.toHash
		meta_hash["config"]				= config.toHash
		meta_hash
	
	end


	def createCollectionPackage

		FileUtils.mkdir_p ["#{self.package_name}/datasource", "#{self.package_name}/delegate", "#{self.package_name}/cell","#{self.package_name}/layout"]


	end

end