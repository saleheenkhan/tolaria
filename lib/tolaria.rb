require "securerandom"
require "digest/md5"

require "sass"
require "bcrypt"

require "tolaria/version"
require "tolaria/engine"
require "tolaria/exceptions"
require "tolaria/config"
require "tolaria/default_config"
require "tolaria/random_tokens"

require "tolaria/display_name"
require "tolaria/routes"
require "tolaria/admin"
require "tolaria/reload"
require "tolaria/manage"

module Tolaria
  # We have to autoload these classes because they inherit
  # from a Rails class (Rails must boot first)
  autoload :TolariaController, "tolaria/controllers/tolaria_controller"
  autoload :ResourceController, "tolaria/controllers/resource_controller"
  autoload :ManagedClass, "tolaria/managed_class"
end
