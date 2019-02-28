# frozen_string_literal: true

module Macro
  def self.Semantic(success: nil, failure: nil, **)
    task = ->((ctx, flow_options), **) {
      ctx[:success_semantic] = success
      ctx[:failure_semantic] = failure

      [Trailblazer::Activity::Right, [ctx, flow_options]]
    }

    { task: task, id: 'semantic' }
  end
end
