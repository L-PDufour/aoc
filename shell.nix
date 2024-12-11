{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Lua implementation and package manager
    luarocks

    lua-language-server
    stylua # Code formatter
    luajitPackages.luacheck
  ];

  shellHook = ''
    echo "🌙 Lua Development Environment Ready!"
    echo "Available tools: lua, luarocks, lua-language-server, stylua, luacheck"
  '';
}
