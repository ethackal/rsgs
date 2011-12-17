require 'sinatra/base'
require 'rubygems/user_interaction'
require 'rubygems/indexer'

class Rsgs < Sinatra::Base

enable :inline_templates
set :static, true
set :root, File.dirname(__FILE__)

get '/' do
  @gemspecs = {}
  gem_indexer.gem_file_list.collect do |gem| 
    @gemspecs[File.basename(gem)] = Gem::Package.open(File.open gem) {|g|g.metadata}
  end
  
  haml :index
end

get '/refresh' do
  refresh_index
  redirect to('/')
end

private
def gem_indexer
  @gemindexer = @gemindexer ||= Gem::Indexer.new("#{::APP_ROOT}/public")
end

def refresh_index
  gem_indexer.generate_index
end


end

__END__

@@ layout
%html
  %head
    :css
      body {
        margin: 0px;
        padding: 0px;
        background-color: #ffffff;
      }

      .header {
        padding: .5em;
        background-color: #3B2016;
        color: #E8C38E;
        font-size: x-large;
        margin-bottom: 1em;
        border-bottom: .1em #B08737 solid;
      }     
      
      li {
        display: block;
        margin: .25em;
        padding: .25em;
        border-bottom: .1em #E8C38E solid;
      }

      a {
        display: block;
        width: 100%;
        text-decoration: none;
        color: #B08737;
      }
       
  %body
    .header
      simple gem server
    = yield

@@ index
%ul
- @gemspecs.each do |gem, spec|
  %li
    %a(href="/gems/#{gem}")
      %span
        = spec.name
      %span 
        = spec.version

