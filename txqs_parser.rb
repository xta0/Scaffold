##author : jayson.xu @taobao inc

require 'nokogiri'
require './txqs_uikit.rb'
require './txqs_mappings.rb'


class XibParser
  
  attr_accessor :path, :f, :doc #Nokogiri::XML::Document
  attr_accessor :view_hash 
  attr_accessor :cell_hash 
  
  def initialize(path)
    @path = path
    @view_hash = Hash.new
    @cell_hash = Hash.new
    open()
    
  end
  
  def open
    @f = File.open(@path)
    @doc = Nokogiri::XML(f)
    @f.close    
  end
  
  def parse

    ##1,find objects
    root_objs = @doc.xpath('//objects/*')
   
    root_objs.each do |o|

      if o.name == 'view'

        tmp = Array.new
        subviews = o.xpath("subviews/*") ## subviews => Nokogiri::XML::NodeSet
        #get subviews class
        subviews.each do |v| ## v => Nokogiri::XML::Element
          
          objc_clz  = MAPPINGS::OBJC_CLASS[v.name]
          objc_name = v.at_xpath('accessibility')["label"] 
          obj = UIKitFactory.UIKitObj(v,objc_name,objc_clz)
    
          tmp << obj
          
        end ##end of subviews.each

        @view_hash[o["customClass"]] = tmp
      
        
      end ##end of if
      
      if o.name == 'tableViewCell'
        
        subviews = o.xpath("tableViewCellContentView/subviews/*")
        tmp = Array.new
        #get subviews class
        subviews.each do |v| ## v => Nokogiri::XML::Element

          objc_clz  = MAPPINGS::OBJC_CLASS[v.name]
          objc_name = v.at_xpath('accessibility')["label"] 
          obj = UIKitFactory.UIKitObj(v,objc_name,objc_clz)
          tmp << obj
          
        end ##end of subviews.each
        
        @cell_hash[o["customClass"]] = tmp
        
      end #end of if
    
    end #end of root_objs.each
        
  end#end of parse


end#end of class