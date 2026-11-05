#!/usr/bin/env ruby
# frozen_string_literal: true

require "json"
require "open3"

module CaskBumpFilter
  # Wait for a pending bump PR to be handled before updating that cask again.
  def self.filter(casks, pull_requests, log: $stdout)
    casks.reject do |cask|
      pending = pull_requests.find do |pr|
        pr.fetch("headRefName").start_with?("bump-#{cask}-") &&
          pr.fetch("files").any? do |file|
            path = file.fetch("path")
            path.start_with?("Casks/") && File.basename(path) == "#{cask}.rb"
          end
      end

      log.puts "Skip #{cask}: pending bump PR #{pending.fetch('url')}" if pending
      pending
    end
  end
end

if $PROGRAM_NAME == __FILE__
  casks = ENV.fetch("CASKS").split(/[,\s]+/).reject(&:empty?).uniq
  abort "CASKS must contain at least one cask" if casks.empty?

  json, status = Open3.capture2(
    "gh", "pr", "list",
    "--repo", ENV.fetch("GITHUB_REPOSITORY"),
    "--base", ENV.fetch("GITHUB_REF_NAME"),
    "--state", "open", "--limit", "1000",
    "--json", "headRefName,files,url"
  )
  abort "Failed to list pending bump PRs" unless status.success?

  remaining = CaskBumpFilter.filter(casks, JSON.parse(json))
  File.open(ENV.fetch("GITHUB_OUTPUT"), "a") do |file|
    file.puts "casks=#{remaining.join(',')}"
  end
  puts "All requested casks have pending bump PRs; nothing to do." if remaining.empty?
end
