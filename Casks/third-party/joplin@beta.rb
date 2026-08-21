cask "joplin@beta" do
  arch arm: "-arm64"

  version "3.7.12"
  sha256 arm:   "a289007f294b9c70ec3a2f73d8d02cac5422d8a4187a2eb367e552587b5b7724",
         intel: "c433143cc0db81dc7ac8ee6a5a89f0ce19f3c9ec59c7e83490c1564410e0bccf"

  url "https://github.com/laurent22/joplin/releases/download/v#{version}/Joplin-#{version}#{arch}.DMG",
      verified: "github.com/laurent22/joplin/"
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
