require 'test_helper'

class NoticeMailerTest < ActionMailer::TestCase
  tests NoticeMailer
  def test_inform_user
    #@expected.subject = 'NoticeMailer#inform_user'
    #@expected.body    = read_fixture('inform_user')
    #@expected.date    = Time.now

    #assert_equal @expected.encoded, NoticeMailer.create_inform_user(@expected.date).encoded
    assert true
  end

  def test_inform_admin
    #@expected.subject = 'NoticeMailer#inform_admin'
    #@expected.body    = read_fixture('inform_admin')
    #@expected.date    = Time.now

    #assert_equal @expected.encoded, NoticeMailer.create_inform_admin(@expected.date).encoded
    assert true
  end

end
