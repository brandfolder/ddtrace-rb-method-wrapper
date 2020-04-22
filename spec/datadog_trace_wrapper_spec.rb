require 'spec_helper'

ENV['DD_TRACE_METHOD_WRAPPER_SERVICE'] = 'rspec'
Datadog.configuration.tracer.enabled = false  # prevents submission attempts

class DatadogTraceWrapperSpec
  extend DatadogTraceWrapper

  trace :wrapped_value, span_type: 'test_span_name'
  trace :wrapped_and_customized_trace, span_type: 'custom_span', service: 'custom_service', resource: 'custom_resource', tags: ['custom_tag1', 'custom_tag2']

  def wrapped_and_customized_trace; end

  def wrapped_value(val)
    val
  end

  def unwrapped_value(val)
    val
  end
end

describe 'DdtraceWrapper' do
  context 'wrap :method' do
    it 'returns expected values' do
      val = 5
      expect(DatadogTraceWrapperSpec.new.wrapped_value(val)).to eq(val)
    end

    it 'wraps the method' do
      expect(Datadog.tracer).to receive(:trace).with('test_span_name', service: ENV['DD_TRACE_METHOD_WRAPPER_SERVICE'], resource: 'DatadogTraceWrapperSpec#wrapped_value')
      DatadogTraceWrapperSpec.new.wrapped_value(1)
    end

    it 'wraps with all the available args' do
      expect(Datadog.tracer).to receive(:trace).with(
        'custom_span',
        service: 'custom_service',
        resource: 'custom_resource',
        tags: ['custom_tag1', 'custom_tag2']
      )
      DatadogTraceWrapperSpec.new.wrapped_and_customized_trace
    end
  end

  context 'unwrapped :method' do
    it 'does not wrap the method' do
      expect(Datadog.tracer).to_not receive(:trace)
      DatadogTraceWrapperSpec.new.unwrapped_value(true)
    end
  end
end
