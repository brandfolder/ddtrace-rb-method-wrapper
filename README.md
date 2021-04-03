# Datadog Trace Client Method Wrapper

[![CircleCI](https://circleci.com/gh/brandfolder/ddtrace-rb-method-wrapper/tree/master.svg?style=svg)](https://circleci.com/gh/brandfolder/ddtrace-rb-method-wrapper/tree/master)

``ddtrace-method-wrapper`` augments Datadog's tracing library `ddtrace` for Ruby.
It adds a convenience method for classes to wrap method execution in custom tracing.

## Getting Started

Load ``ddtrace_method_wrapper``, extend the desired class or module, and specify the methods to trace.
The ``span_type`` keyword argument is required.

```
require 'ddtrace_method_wrapper'

class MyInstrumentedClass
  extend DatadogTraceWrapper

  trace :method1, :method2, span_type: 'web'

  def method1
    ...
  end

  def method2
    ...
  end

  # Not instrumented
  def method3
    ...
  end
end
```


For more specific configuration, Datadog tracing allows for a variety of options which are passed through
https://docs.datadoghq.com/tracing/setup_overview/setup/ruby/#manual-instrumentation.
