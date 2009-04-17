class NaniteJob < ActiveRecord::Base
  include NaniteJobMixin
  extend  NaniteJobExt

  serialize :arguments, Array

  validates_presence_of :target_class
  validates_presence_of :method

  named_scope :pending_jobs, {:conditions => {:performed => false}, :order => "priority ASC"}
  named_scope :failed_jobs, {:conditions => {:failed => true}, :order => "priority ASC"}
end
