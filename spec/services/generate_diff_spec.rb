require 'spec_helper'
require 'ostruct'

class GenerateDiffSpec < BaseSpec
  let(:local) { OpenStruct.new(name: 'john', age: 23) }
  let(:remote) do
    {
      reference: '001',
      name: 'john s.',
      age: 23
    }
  end
  let(:result) { Services::GenerateDiff.call(local, remote) }

  describe 'when no differences exist between local and remote' do
    before { remote[:name] = 'john' }

    it 'returns nil' do
      assert_nil result
    end
  end

  describe 'when differences exist between local and remote' do
    it 'compiles differences and returns the results' do
      assert_equal remote[:reference], result[:remote_reference]
      assert_equal 1, result[:diff].size

      assert_equal local.name, result[:diff][:name][:local]
      assert_equal remote[:name], result[:diff][:name][:remote]
    end
  end
end
