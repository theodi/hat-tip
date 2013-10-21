$:.unshift File.join(File.dirname(__FILE__), "lib")

require 'rubygems' 
require 'bundler'  
Bundler.require 

require 'date'
require 'dataset'
require 'doi_dataset'
require 'application'

run HatTipApp