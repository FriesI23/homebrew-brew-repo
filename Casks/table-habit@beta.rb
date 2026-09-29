cask "table-habit@beta" do
  version "1.27.10+199"
  sha256 "c8d043584fe1885bbe5f67efa68b0d273db90b29f5fd692e6171528abcd758ba"

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
