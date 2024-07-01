# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityChangePasswordTest < Minitest::Test

      context "XPack Security: Change password" do
        subject { FakeClient.new }

        should "perform correct request for a specific user" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_security/user/foo/_password', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:password]
            true
          end.returns(FakeResponse.new)

          subject.security.change_password username: 'foo', body: { password: 'bar' }
        end

        should "perform correct request for current user" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'PUT', method
            assert_equal '_security/user/_password', url
            assert_equal Hash.new, params
            assert_equal 'bar', body[:password]
            true
          end.returns(FakeResponse.new)

          subject.security.change_password body: { password: 'bar' }
        end

      end

    end
  end
end
