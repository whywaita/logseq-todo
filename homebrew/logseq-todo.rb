cask "logseq-todo" do
  version "0.1.6"
  sha256 "93dc1e02fd40fdb6350a21f41d1a9c3208c1994793808354d57ecf2204008b6e"

  url "https://github.com/whywaita/logseq-todo/releases/download/v#{version}/LogseqTodo-#{version}.zip"
  name "Logseq TODO"
  desc "Menu bar app for Logseq TODO tasks"
  homepage "https://github.com/whywaita/logseq-todo"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "LogseqTodo.app"

  uninstall quit: "com.whywaita.logseq-todo"

  zap trash: [
    "~/Library/Preferences/com.whywaita.logseq-todo.plist",
    "~/Library/Application Support/LogseqTodo",
  ]
end