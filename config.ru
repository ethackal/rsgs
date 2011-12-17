$:.unshift File.dirname(__FILE__)

require 'sinatra'
require 'rsgs'

APP_ROOT = File.expand_path(".")

run Rsgs
