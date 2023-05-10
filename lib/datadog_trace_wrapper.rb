# CoreUsage:
# extend DatadogTraceWrapper
module DatadogTraceWrapper

  # Instructs the class to wrap methods for custom datadog tracing
  #
  # == Parameters:
  # *method_names::
  #   A list of method name symbols to trace
  #   `:method1, :method2`
  # span_type::
  #   Keyword argument (string) specifying the name of the span
  #
  # == Optional Parameters:
  # service::
  #   String specifying the service to include this span within.
  #   Defaults to DD_TRACE_METHOD_WRAPPER_SERVICE
  # resource::
  #   String specifying what to call the trace segment in the span
  #   Defaults to ClassName#Method
  # trace_kwargs::
  #   Keyword arguments passed through to Datadog.tracer.trace, listed here:
  #   https://docs.datadoghq.com/tracing/setup_overview/setup/ruby/#manual-instrumentation
  def trace(*method_names, span_type:, service: nil, resource: nil, **trace_kwargs)

    method_names.each do |m|
      proxy = Module.new do
        define_method(m) do |*args, **kwargs|
          service  ||= ENV['DD_TRACE_METHOD_WRAPPER_SERVICE']
          resource ||= "#{self.class.name}##{m}"
          Datadog::Tracing.trace(
            span_type,
            service: service,
            resource: resource,
            **trace_kwargs
          ) do
            super(*args, **kwargs)
          end
        end
      end

      prepend proxy
    end
  end
end
