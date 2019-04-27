
Pod::Spec.new do |s|
  s.name             = "TraceLogAdaptiveWriter"
  s.version          = "1.0.1"
  s.summary          = "An adaptive system log writer for the TraceLog logging system."
  s.description      = <<-DESC
                        A `Writer` implementation for the TraceLog logging system that logs to the system logging facility on the platform that its running on.

                            - **Linux**: On Linux it will writer to the systemd journal.
                            - **Darwin**: On Darwin platforms (macOS, iOS, tvOS, watchOS) it will write to the Unified Logging System.

                        See [TraceLog](https://github.com/tonystone/tracelog) for more details.
                       DESC
  s.license          = 'Apache License, Version 2.0'
  s.homepage         = "https://github.com/tonystone/tracelog-adaptive-writer"
  s.author           = { "Tony Stone" => "https://github.com/tonystone" }
  s.source           = { :git => "https://github.com/tonystone/tracelog-adaptive-writer.git", :tag => s.version.to_s }

  s.swift_version = '4.1'

  s.ios.deployment_target     = '10.0'
  s.osx.deployment_target     = '10.12'
  s.watchos.deployment_target = '3.0'
  s.tvos.deployment_target    = '10.0'

  s.requires_arc = true

  s.source_files = 'Sources/TraceLogAdaptiveWriter/**/*.swift'

  s.dependency 'TraceLog', ">= 4.0.1", "< 5.0.0"
end
