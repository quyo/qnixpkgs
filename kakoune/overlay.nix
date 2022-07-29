final: prev:
{
  kakoune = prev.kakoune.override {
    plugins = with final.kakounePlugins; [
      kakoune-easymotion
      kakoune-extra-filetypes
    ];
  };
}
