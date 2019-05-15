# NOTE: This class makes the following assumptions:
# 1. 'local' is an object
# 2. 'remote' is a hash
# 3. 'remote' has a key 'reference'
# 4. 'local' and 'remote' have at least one matching attribute/key combo

module Services
  class GenerateDiff
    def self.call(local, remote)
      new(local, remote).call
    end

    def initialize(local, remote)
      @local = local
      @remote = remote
    end

    # NOTE: I chose "diff" rather than "discrepancies" because it's shorter,
    # easier to spell, and is semantically anchored to the 'diff' utility
    def call
      return if same_description? && same_status?
      {
        remote_reference: remote.delete(:reference),
        diff: build_diff
      }
    end

    private
    attr_reader :local, :diff, :remote

    def build_diff
      remote.keys.inject(Hash.new) do |result, key|
        if no_diff?(key)
          result
        else
          result[key] = {
            local: local.public_send(key),
            remote: remote[key]
          }

          result
        end
      end
    end

    def no_diff?(attribute)
      remote[attribute] == local.public_send(attribute)
    end
  end
end
