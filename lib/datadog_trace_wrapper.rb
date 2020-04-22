module DatadogTraceWrapper
  def trace(*method_names, span_type:, service: nil, resource: nil, **trace_kwargs)

    method_names.each do |m|
      proxy = Module.new do
        define_method(m) do |*args, **kwargs|
          service  ||= ENV['DD_TRACE_METHOD_WRAPPER_SERVICE']
          resource ||= "#{self.class.name}##{m.to_s}"
          Datadog.tracer.trace(
            span_type,
            service: service,
            resource: resource,
            **trace_kwargs
          ) do
            super(*args, **kwargs)
          end
        end
      end

      self.prepend proxy
    end
  end
end
