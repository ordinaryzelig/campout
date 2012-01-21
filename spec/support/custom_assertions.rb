module MiniTest::Assertions

  def assert_expect_to_send_DM(account, message)
    Twitter.expects(:direct_message_create).with(account.user_id, message)
  end

end

module MiniTest::Expectations
  infect_an_assertion :assert_expect_to_send_DM, :must_expect_to_send_DM, :reverse
end
