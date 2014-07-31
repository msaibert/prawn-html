# encoding: utf-8
module Prawn

require "prawn/html/version"
require 'nokogiri'
  
  class HTML
  	
  	module Interface

	    def html(source)
	    	HTML.new(source, self)
	    end
      
  	end

    attr

  	def initialize(source, document, options={})
      @pdf = document
      options.each { |k, v| send("#{k}=", v) }
      recursive(Nokogiri::HTML(source).elements)
    end

    private

    def recursive(elements)
      elements.each do |element| 
        case element.name 
          when 'input' then html_input element
          when 'p' then html_text element
          when 'table' then html_table element.to_s
          else recursive(element.elements)
        end
      end
    end

    def html_text(element)
      if element.elements.count.zero?
        @pdf.text element.text, inline_format: true
      else
        recursive(element.elements)
      end
    end

    def html_input(element)
      @pdf.text input_to_text(element)
    end

    def html_table(source)
      n = Nokogiri::HTML(source);  
      data = nil
      options = {cell_style: {}}
      n.search('table').each do |table|
        
        #get a styles from table and convert in hash
        styles = table.attr('style').to_s.split(';').inject({}) {|hash, v| v = v.split(':'); hash[v.first.delete(' ')] = v.last; hash}
        
        #get options for table
        options[:align] = table.attr('align').to_sym rescue nil
        options[:cell_style][:background_color] = styles['background-color'].gsub(/\W/, '') rescue nil

        data = table.search('tr').collect do |tr| 
          tr.search('td,th').collect do |td|
            td.text
          end.flatten
        end
      end

      @pdf.table data, options.select{|k, v| !v.nil?}
    end



    #conversion methods
    def input_to_text(element)
      case element.attr('type')
        when 'text' then element.attr('value').to_s
        when 'checkbox' then element.attr('checked') ? '(x)' : '( )'
      end
    end

	end
end


Prawn::Document.extensions << Prawn::HTML::Interface