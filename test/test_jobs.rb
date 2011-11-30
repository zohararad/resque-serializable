# Mock job for unit tests
class MockJob #:nodoc:

  @queue = :test

  def self.perform(i,s,h)
    $job_args = {
      'i' => i,
      's' => s,
      'h' => h
    }
  end

end