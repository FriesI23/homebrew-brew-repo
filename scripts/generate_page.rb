#!/usr/bin/env ruby
# frozen_string_literal: true

# Generates a static index.html listing every Cask in this tap, for
# publishing to GitHub Pages. Parses the Cask DSL with regexes instead of
# loading Homebrew, so it can run on a plain Ubuntu runner with no brew
# install step.

require "erb"
require "cgi"
require "fileutils"

REPO_ROOT = File.expand_path("..", __dir__)
CASKS_DIR = File.join(REPO_ROOT, "Casks")
TEMPLATE_DIR = File.join(__dir__, "templates")
OUTPUT_DIR = ARGV[0] || File.join(REPO_ROOT, "_site")
CUSTOM_DOMAIN = ENV["PAGES_CNAME"]

TapInfo = Struct.new(:token, :name, :desc, :homepage, :version, :auto_updates, :origin, keyword_init: true)

def extract(field, content)
  content[/^\s*#{field}\s+"([^"]*)"/, 1]
end

# Each Cask file declares its origin via a leading comment, e.g.:
#   # tap_origin: self
# "self" casks package software this tap's owner develops; anything else
# (or a missing tag) is treated as a third-party package.
def parse_origin(content)
  content[/^#\s*tap_origin:\s*(\S+)/, 1] == "self" ? :self : :third_party
end

def parse_cask(path)
  content = File.read(path)
  token = content[/^cask\s+"([^"]+)"/, 1] || File.basename(path, ".rb")

  TapInfo.new(
    token: token,
    name: extract("name", content) || token,
    desc: extract("desc", content) || "",
    homepage: extract("homepage", content) || "",
    version: extract("version", content) || "",
    auto_updates: content[/^\s*auto_updates\s+(true|false)/, 1] == "true",
    origin: parse_origin(content)
  )
end

casks = Dir.glob(File.join(CASKS_DIR, "*.rb")).sort.map { |f| parse_cask(f) }

repo = ENV["GITHUB_REPOSITORY"] || "FriesI23/homebrew-brew-repo"
tap_owner, repo_name = repo.split("/", 2)
tap_name = repo_name.sub(/^homebrew-/, "")
tap_qualified = "#{tap_owner}/#{tap_name}"

template = File.read(File.join(TEMPLATE_DIR, "index.html.erb"))
html = ERB.new(template, trim_mode: "-").result(binding)

FileUtils.mkdir_p(OUTPUT_DIR)
File.write(File.join(OUTPUT_DIR, "index.html"), html)
FileUtils.cp(File.join(TEMPLATE_DIR, "style.css"), File.join(OUTPUT_DIR, "style.css"))
FileUtils.cp(File.join(TEMPLATE_DIR, "script.js"), File.join(OUTPUT_DIR, "script.js"))
File.write(File.join(OUTPUT_DIR, "CNAME"), "#{CUSTOM_DOMAIN}\n") if CUSTOM_DOMAIN && !CUSTOM_DOMAIN.empty?
puts "Wrote #{File.join(OUTPUT_DIR, 'index.html')} (#{casks.size} cask(s))"
