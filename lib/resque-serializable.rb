require "resque-serializable/version"
require "resque-serializable/job"

module Resque
  class Job
    include Resque::Serializable::Job
  end
end