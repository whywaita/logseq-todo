cask "logseq-todo" do
  version "main"
  sha256 "e9fee201b20ab820b0768c37edfad51c5b2f6a00512078c2afd2b3783a24aac8"

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