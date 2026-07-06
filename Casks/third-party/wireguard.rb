cask "wireguard" do
  version "1.0.16"
  sha256 "df84eab7d5b991164d508c1a4c8596d428a4cf6a20cc201716adc0cf0f6bed75"

  url "https://github.com/mintc2/wireguard-macos-app/releases/download/v#{version}/wireguard_#{version.to_s.tr(".", "_")}.zip",
      verified: "github.com/mintc2/wireguard-macos-app/"
  name "WireGuard"
  desc "WireGuard UI universal Apple application"
  homepage "https://github.com/mintc2/wireguard-macos-app"

  livecheck do
    url :url
    strategy :github_latest do |json|
      json["tag_name"].delete_prefix("v")
    end
  end

  depends_on macos: ">= :monterey"

  app "WireGuard.app"

  zap trash: [
    "~/Library/Application Scripts/com.wireguard.macos",
    "~/Library/Application Scripts/com.wireguard.macos.login-item-helper",
    "~/Library/Application Scripts/com.wireguard.macos.network-extension",
    "~/Library/Containers/com.wireguard.macos",
    "~/Library/Containers/com.wireguard.macos.login-item-helper",
    "~/Library/Containers/com.wireguard.macos.network-extension",
    "~/Library/Group Containers/*.group.com.wireguard.macos",
  ]
end
