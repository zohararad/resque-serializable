dir = File.dirname(File.expand_path(__FILE__))
require dir + '/test_helper'

class SerializableJobArgsTest < Test::Unit::TestCase
  def setup
    $job_args = nil
    Resque.redis.flushall
    @worker = Resque::Worker.new(:test)
  end

  def test_version
    major, minor, patch = Resque::Version.split('.')
    assert_equal 1, major.to_i
    assert minor.to_i >= 19
  end

  def test_normal_job_args
    Resque.enqueue(MockJob,1,'hello',{'key' => 'value'})
    @worker.process
    assert_equal 1, $job_args['i'], 'integer argument should be equal 1'
    assert_equal "hello", $job_args['s'], 'string argument should be equal "hello"'
    assert $job_args['h'].is_a?(Hash), 'hash argument should be a hash'
    assert_equal 'value', $job_args['h']['key'], 'hash "key" property should equal "value"'
  end
  
  def test_serializable_job_args_array
    Resque.enqueue(MockJob,1,'hello',:serialize => [{'key' => 'value'}])
    @worker.process
    assert_equal 1, $job_args['i'], 'integer argument should be equal 1'
    assert_equal "hello", $job_args['s'], 'string argument should be equal "hello"'
    assert $job_args['h'].is_a?(Hash), 'hash argument should be a hash'
    assert_equal 'value', $job_args['h']['key'], 'hash "key" property should equal "value"'
  end
  
  def test_serializable_job_args_hash
    Resque.enqueue(MockJob,1,'hello',:serialize => {'some_hash' => {'key' => 'value'}})
    @worker.process
    assert_equal 1, $job_args['i'], 'integer argument should be equal 1'
    assert_equal "hello", $job_args['s'], 'string argument should be equal "hello"'
    assert $job_args['h'].is_a?(Hash), 'hash argument should be a hash'
    assert_equal 'value', $job_args['h']['key'], 'hash "key" property should equal "value"'
  end
  
  def test_resque_lint
    assert_nothing_raised do
      Resque::Plugin.lint(Resque::Serializable::Job)
    end
  end
end