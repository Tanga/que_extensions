class Que::PeriodicJob < Que::Job
  INTERVAL = 60
  DELAY = 0
  attr_reader :start_at, :end_at, :run_again_at, :time_range
  def _run
    args = attrs[:args].first || {}

    start_at = args.delete('start_at')
    end_at   = args.delete('end_at')

    if start_at.present? && end_at.present?
      @start_at = Time.parse(start_at)
      @end_at   = Time.parse(end_at)
    else
      @start_at = Time.current
      @end_at   = @start_at + self.class::INTERVAL
    end

    @run_again_at = @end_at
    @time_range = @start_at...@end_at

    super

    args['start_at'] = @end_at
    args['end_at']   = @end_at + self.class::INTERVAL

    Que.transaction do
      self.class.enqueue(args, run_at: @run_again_at + self.class::DELAY)
      destroy
    end
  end

  def test_job
    @time_range = attrs.delete(:time_range)
    run(attrs)
  end
end
