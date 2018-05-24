$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "range_component_attributes"

require "minitest/autorun"
require "minitest/reporters"
Minitest::Reporters.use!

require "active_record"
require "yaml"

database_config = YAML.load_file(File.expand_path("../database.yml", __FILE__))
ActiveRecord::Base.establish_connection database_config["test"]
