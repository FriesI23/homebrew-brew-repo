# frozen_string_literal: true

require "minitest/autorun"
require "stringio"
require_relative "filter_bump_casks"

class CaskBumpFilterTest < Minitest::Test
  def bump_pr(cask, directory: "Casks/third-party", branch: "bump-#{cask}-1.0.1")
    {
      "headRefName" => branch,
      "files" => [{ "path" => "#{directory}/#{cask}.rb" }],
      "url" => "https://github.com/FriesI23/homebrew-brew-repo/pull/119",
    }
  end

  def filter(casks, prs)
    CaskBumpFilter.filter(casks, prs, log: StringIO.new)
  end

  def test_no_pending_prs
    assert_equal %w[iloader penpot-desktop], filter(%w[iloader penpot-desktop], [])
  end

  def test_existing_penpot_pr_does_not_block_other_casks
    casks = %w[iloader joplin@beta penpot-desktop wireguard]
    assert_equal %w[iloader joplin@beta wireguard], filter(casks, [bump_pr("penpot-desktop")])
  end

  def test_all_casks_pending
    assert_empty filter(["penpot-desktop"], [bump_pr("penpot-desktop")])
  end

  def test_root_and_beta_casks
    casks = %w[table-habit table-habit@beta]
    prs = casks.map { |cask| bump_pr(cask, directory: "Casks") }
    assert_empty filter(casks, prs)
  end

  def test_unrelated_branch_does_not_block_update
    pr = bump_pr("penpot-desktop", branch: "fix-penpot-desktop")
    assert_equal ["penpot-desktop"], filter(["penpot-desktop"], [pr])
  end

  def test_similar_cask_name_does_not_block_update
    pr = bump_pr("penpot-desktop-extra")
    assert_equal ["penpot-desktop"], filter(["penpot-desktop"], [pr])
  end

  def test_non_cask_file_does_not_block_update
    pr = bump_pr("penpot-desktop", directory: "scripts")
    assert_equal ["penpot-desktop"], filter(["penpot-desktop"], [pr])
  end

  def test_skip_log_links_to_pending_pr
    log = StringIO.new
    pr = bump_pr("penpot-desktop")
    CaskBumpFilter.filter(["penpot-desktop"], [pr], log: log)
    assert_includes log.string, "Skip penpot-desktop: pending bump PR #{pr.fetch('url')}"
  end
end
