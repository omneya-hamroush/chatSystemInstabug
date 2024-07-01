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

require 'spec_helper'

describe 'client#ml.start_trained_model_deployment' do
  let(:expected_args) do
    [
      'POST',
      '_ml/trained_models/foo/deployment/_start',
      {},
      nil,
      {},
      { defined_params: { model_id: 'foo' },
        endpoint: 'ml.start_trained_model_deployment' }
    ]
  end

  it 'performs the request' do
    expect(client_double.ml.start_trained_model_deployment(model_id: 'foo')).to be_a Elasticsearch::API::Response
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  context 'when a model_id is not provided' do
    it 'raises an exception' do
      expect {
        client.ml.start_trained_model_deployment
      }.to raise_exception(ArgumentError)
    end
  end
end
