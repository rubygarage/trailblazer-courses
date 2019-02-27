# frozen_string_literal: true

module DefaultEndpoint
  protected

  def default_handler
    lambda do |match|
      match.destroyed { |_result| head(:no_content) }
      match.forbidden { |_result| head(:forbidden) }
      match.invalid { |result| render_errors(result, :unprocessable_entity) }
      match.success { |result| render_response(result, :ok) }
    end
  end

  def endpoint(operation_class, options = {}, &block)
    ApplicationEndpoint.call(operation_class, default_handler, { **options, params: params.to_unsafe_hash }, &block)
  end

  private

  def render_errors(result, status)
    render jsonapi_errors: result['contract.default']&.errors || result[:errors],
           class: {
             'Reform::Contract::Errors': Lib::Representer::ReformErrorsSerializer,
             Hash: Lib::Representer::HashErrorsSerializer
           },
           status: status
  end

  def render_response(result, status)
    render jsonapi: result[:model], **result[:renderer_options], include: params[:include], status: status
  end
end
