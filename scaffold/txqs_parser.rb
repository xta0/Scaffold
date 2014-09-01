##author : jayson.xu @taobao inc

require 'nokogiri'
require './txqs_uikit.rb'
require './txqs_mappings.rb'


class XibParser
  
  attr_accessor :path, :f, :doc #Nokogiri::XML::Document
  attr_accessor :view_hash 
  
  def initialize(path)
    @path = path
    @view_hash = Hash.new
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

      if( o.name == 'view' || o.name == 'tableViewCell' )

        tmp = Array.new
        subviews = nil
        
        if o.name == 'view'
          subviews = o.xpath("subviews/*") ## subviews => Nokogiri::XML::NodeSet
        end
        
        if o.name == 'tableViewCell'
          subviews = o.xpath("tableViewCellContentView/subviews/*")
        end

        #get subviews class
        if (subviews)
          subviews.each do |v| ## v => Nokogiri::XML::Element
 
            objc_clz  = v["customClass"] ? v["customClass"] : MAPPINGS::OBJC_CLASS[v.name]
            objc_name = v.at_xpath('accessibility')["label"] 
            obj = UIKitFactory.UIKitObj(v,objc_name,objc_clz)
          
            ##custom import list
            customClass = v["customClass"]
            if customClass
              obj.customClz = true
            end
    
            tmp << obj
          
          end ##end of subviews.each
        
          #background color
          color = o.at_xpath("color")
          bkColor = nil
          if color && color["key"] == "backgroundColor"
            bkColor = MAPPINGS.colorWithObject(color)
          end
        
          @view_hash[o["customClass"]] = {"clz"=>o.name,"bkcolor"=> bkColor , "subviews" => tmp}
        end #end of if (subviews)
        
      end ##end of if      
    
    end #end of root_objs.each
    
   return @view_hash
        
  end#end of parse


end#end of class