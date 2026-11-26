cask "joplin@beta" do
  arch arm: "-arm64"

  version "3.8.4"
  sha256 arm:   "0a51a0b32a71a22b7c58f5867366cc0917d3123d7c17224db668d9d09d46222a",
         intel: "95498ee978acf249bdc08d2184b538dd2151b4db2dc33b1eee880565c8e2c5a3"

  url "https://github.com/laurent22/joplin/releases/download/v#{version}/Joplin-#{version}#{arch}.DMG"
  name "Joplin Beta"
  desc "Pre-release of the note taking and to-do application"
  homepage "https://joplinapp.org/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"] || !release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        asset_names = release["assets"]&.filter_map { |asset| asset["name"] } || []
        expected_assets = ["Joplin-#{match[1]}-arm64.DMG", "Joplin-#{match[1]}.dmg"]
        has_all_assets = expected_assets.all? do |expected|
          asset_names.any? { |name| name.casecmp?(expected) }
        end
        next unless has_all_assets

        match[1]
      end
    end
  end

  conflicts_with cask: "joplin"
  depends_on macos: :monterey

  app "Joplin.app"

  zap trash: [
    "~/Library/Application Support/Joplin",
    "~/Library/Preferences/net.cozic.joplin-desktop.helper.plist",
    "~/Library/Preferences/net.cozic.joplin-desktop.plist",
    "~/Library/Saved Application State/net.cozic.joplin-desktop.savedState",
  ]

  caveats <<~EOS
    Joplin 3.7 upgrades the local profile and raises the minimum sync version.
    Back up your profile and update every syncing device to Joplin 3.7 or newer
    before using this pre-release. Downgrading to Joplin 3.6 may not be possible.
  EOS
end
