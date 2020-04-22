require 'ddtrace'
require 'benchmark'
require_relative './lib/ddtrace_method_wrapper'

n = 100_000

class DatadogTraceWrapperBenchmarkUnwrapped
  def method; end
end

class DatadogTraceWrapperBenchmarkWrapped
  extend DatadogTraceWrapper
  trace :method, span_type: 'benchmark'

  def method; end
end

class DatadogTraceWrapperBenchmarkManualInstrumentation
  def method
    Datadog.tracer.trace('benchmark') do
    end
  end
end

Benchmark.bm do |benchmark|
  benchmark.report("configured class init and execute") do
    Datadog.configuration.tracer.enabled = true
    n.times do
      DatadogTraceWrapperBenchmarkWrapped.new.method
    end
  end

  benchmark.report("configured class init and execute enabled=false") do
    Datadog.configuration.tracer.enabled = false
    n.times do
      DatadogTraceWrapperBenchmarkWrapped.new.method
    end
  end

  benchmark.report("manual instrumentation class execute") do
    Datadog.configuration.tracer.enabled = true
    n.times do
      DatadogTraceWrapperBenchmarkManualInstrumentation.new.method
    end
  end

  benchmark.report("unconfigured class init and execute") do
    n.times do
      DatadogTraceWrapperBenchmarkUnwrapped.new.method
    end
  end

  benchmark.report("configured class execute") do
    Datadog.configuration.tracer.enabled = true
    inst = DatadogTraceWrapperBenchmarkWrapped.new
    n.times do
      inst.method
    end
  end

  benchmark.report("configured class execute enabled=false") do
    Datadog.configuration.tracer.enabled = false
    inst = DatadogTraceWrapperBenchmarkWrapped.new
    n.times do
      inst.method
    end
  end

  benchmark.report("manual instrumentation class execute") do
    Datadog.configuration.tracer.enabled = true
    inst = DatadogTraceWrapperBenchmarkManualInstrumentation.new
    n.times do
      inst.method
    end
  end

  benchmark.report("unconfigured class execute") do
    inst = DatadogTraceWrapperBenchmarkUnwrapped.new
    n.times do
      inst.method
    end
  end
end
