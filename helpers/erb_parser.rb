require 'erb'
require_relative './erb_context'

class ERBParser
  def self.parse(context, path_to_file)
    erb = ERB.new(File.read(File.expand_path(path_to_file)))
    erb_context = ERBContext.new(context)
    erb_binding = erb_context.get_binding
    erb.result(erb_binding)
  end
end
