#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'json'

BUILD_DIR = 'build'

def dotnet_base_path
  info = `dotnet --info`
  info.match(/Base Path:\s+(.*)\s*/)[1]
end

def cat(filename, content = nil)
  name = File.join(BUILD_DIR, filename)
  unless content.nil?
    File.open(name, 'w') do |f|
      f.puts content
    end
  end
  name
end

LANGS = {
  'Go/gccgo' => -> { `gccgo -dumpfullversion` },
  'Go' => lambda do
    prog = <<~GO
      package main
      import (
        "fmt"
        "runtime"
      )
      func main() {
        fmt.Printf(runtime.Version())
      }
    GO
    `go run #{cat('go.go', prog)}`
  end,
  'Node.js' => -> { `node -e "console.log(process.version)"` },
  'Python' => lambda do
    `python3 -c "import platform;print(platform.python_version())"`
  end,
  'Lua' => -> { `lua -v`.split[1] },
  'Lua/luajit' => -> { `luajit -v`.split[1] },
}.freeze

def pad(num, str, padstr)
  str.strip.ljust(num, padstr)
end

def lpad(str, padstr = ' ')
  pad(16, str, padstr)
end

def rpad(str, padstr = ' ')
  pad(31, str, padstr)
end

def versions
  table = [
    "| #{lpad('Language')} | #{rpad('Version')} |",
    "| #{lpad('-', '-')} | #{rpad('-', '-')} |"
  ]
  LANGS.sort.each do |name, version_lambda|
    warn "Fetching #{name} version..."
    version = version_lambda.call
    table << "| #{lpad(name)} | #{rpad(version)} |"
  end

  table.join("\n")
end

FileUtils.mkdir_p BUILD_DIR
puts versions
warn "\n"
FileUtils.rm_r BUILD_DIR
