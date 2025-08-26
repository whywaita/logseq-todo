cask "logseq-todo" do
  version "main"
  sha256 "28ccd3b4df5ee345e63c9774b3b1f1f246ca3fa28275292edab161eb451bd109"

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