# Put your code that runs your task inside the do_work method it will be
# run automatically in a thread. You have access to all of your rails
# models.  You also get logger and results method inside of this class
# by default.
class ScheduledReleaseWorker < BackgrounDRb::Worker::RailsBase

  def do_work(args)
    # This method is called in it's own new thread when you
    # call new worker. args is set to :args
    logger.error "Checking for chapters to release..."
    chapters_to_release = Chapter.find(:all, :conditions => "release_on < NOW() and status != 'released'")
    chapters_to_release.each do |chapter|
      chapter.status = 'released';
      chapter.save
      logger.error "Released #{chapter.story.title} Chapter #{chapter.number}"
    end
  end

end
ScheduledReleaseWorker.register
