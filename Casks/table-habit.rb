cask "table-habit" do
  version "1.21.1+120"
  sha256 "67eabd205c8b8d9872b05598554ddec95a1ee0ea28949462cfac7b5bbdf450bb"

  url "https://github.com/FriesI23/mhabit/releases/download/v#{version}/mhabit.dmg"
  name "Table Habit"
  desc "Simple habit tracker"
  homepage "https://github.com/FriesI23/mhabit"

  livecheck do
    url :url
    strategy :github_latest do |json|
      json["tag_name"].delete_prefix("v")
    end
  end

  auto_updates false
  conflicts_with cask: "table-habit@beta"
  depends_on macos: ">= :catalina"

  app "mhabit.app"

  preflight do
    system_command "xattr",
                   args: ["-d", "com.apple.quarantine", "#{staged_path}/mhabit.app"]
    if system_command("pgrep", args: ["-x", "mhabit"], print_stderr: false).exit_status == 0
      system_command "osascript",
                     args: ["-e", 'tell application "mhabit" to quit']
      File.write("/tmp/mhabit_was_running", "1")
    end
    File.write("/tmp/mhabit_installed_version", version)
  end

  postflight do
    if File.exist?("/tmp/mhabit_installed_version")
      installed_version = File.read("/tmp/mhabit_installed_version").strip
      if installed_version != "#{version}"
        odie "Version mismatch! Expected #{version}, but got #{installed_version}."
      end
      File.delete("/tmp/mhabit_installed_version")
    end
    if File.exist?("/tmp/mhabit_was_running")
      system_command "open", args: ["-a", "mhabit"]
      File.delete("/tmp/mhabit_was_running")
    end
  end

  zap trash: [
    "~/Library/Application Support/io.github.friesi23.mhabit",
    "~/Library/Caches/io.github.friesi23.mhabit",
    "~/Library/Preferences/io.github.friesi23.mhabit.plist",
  ]
end