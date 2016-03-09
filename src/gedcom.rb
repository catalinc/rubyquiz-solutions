#!/usr/bin/env ruby

require 'rubygems'
require 'libxml'
require 'pp'

include LibXML

def to_xml(in_file, out_file)
  File.open(in_file, 'r') do |f|
    doc = XML::Document.new
    doc.root = XML::Node.new('gedcom')
    stack = [doc.root]

    f.each_line do |l|
      next if l =~ /^\s*$/
      l =~ /\s*(\d+)\s+([@]?\S+[@]?)(\s+([\S\s]+))?/ or raise "Invalid GEDCOM entry: #{l}"
      level = $1.to_i
      tag_or_id = $2
      data = $4
      if data
        data.chomp!
      end
      
      # find parent node
      while level+1 < stack.size
        stack.pop
      end
      parent = stack.last
      
      el = nil
      if tag_or_id =~ /@.+@/
        el = XML::Node.new(data)
        el.attributes['id'] = tag_or_id
      else
        el = XML::Node.new(tag_or_id)
        el << data
      end
      parent << el
      stack.push(el)
    end

    doc.save(out_file, :indent => true, :encoding => XML::Encoding::UTF_8)
  end
end

if $0 == __FILE__
  if ARGV.size == 2
    to_xml(ARGV[0], ARGV[1])
  else
    puts "usage: ./gedcom.rb INPUT_GEDCOM_FILE OUTPUT_XML_FILE"
  end
end
