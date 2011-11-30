require "resque-serializable/version"
require "resque-serializable/job"
require 'yaml'

module Resque #:nodoc:
  class Job #:nodoc:
    include Resque::Serializable::Job
  end
end