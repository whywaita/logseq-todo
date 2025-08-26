cask "logseq-todo" do
  version "0.1.8"
  sha256 "daa400c62ebdffedc186280cb4be7193d15fe5d091ec8bc5166fb820b9fbfdf9"

  url "https://github.com/whywaita/logseq-todo/releases/download/v#{version}/LogseqTodo-#{version}.zip"
  name "Logseq TODO"
  desc "Menu bar app for Logseq TODO tasks"
  homepage "https://github.com/whywaita/logseq-todo"

  depends_on macos: ">= :sequoia"
  depends_on arch: :arm64

  app "LogseqTodo.app"

  uninstall quit: "it.whywrite.logseq-todo"

  zap trash: [
    "~/Library/Preferences/it.whywrite.logseq-todo.plist",
    "~/Library/Application Support/LogseqTodo",
  ]
end