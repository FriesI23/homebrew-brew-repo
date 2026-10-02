cask "table-habit@beta" do
  version "1.27.11+200"
  sha256 "f147100cee01220fbdd90674bc8ff605bf9bbc7369b969cdc4f1e47b282094e7"

  url "https://github.com/FriesI23/mhabit/releases/download/pre-v#{version}/mhabit.dmg"
  name "Table Habit"
  desc "Simple habit tracker"
  homepage "https://github.com/FriesI23/mhabit"

  livecheck do
    url :url
    strategy :github_releases do |json, _regex|
      versions = json.map do |release|
        tag = release["tag_name"]
        tag.sub(/^pre-v/, "")
      end
      versions.map { |v| Version.new(v) }.max.to_s
    end
  end

  auto_updates false
  conflicts_with cask: "table-habit"
  depends_on :macos

  app "mhabit.app"

  preflight_steps do
    run "xattr", args: ["-d", "com.apple.quarantine", "{{staged_path}}/mhabit.app"]
  end

  zap trash: [
    "~/Library/Application Support/io.github.friesi23.mhabit",
    "~/Library/Caches/io.github.friesi23.mhabit",
    "~/Library/Preferences/io.github.friesi23.mhabit.plist",
  ]
end
