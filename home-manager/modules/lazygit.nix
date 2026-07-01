{ config, pkgs, ... }: {
    programs.lazygit = {
        enable = true;
        settings = {
            gui = {
                theme = {
                    activeBorderColor = [ "#a7c080" "bold" ];
                    inactiveBorderColor = [ "#495156" ];
                    optionsTextColor = [ "#7fbbb3" ];
                    selectedLineBgColor = [ "#2e383c" ];
                    selectedRangeBgColor = [ "#2e383c" ];
                    cherryPickedCommitBgColor = [ "#414b50" ];
                    cherryPickedCommitFgColor = [ "#a7c080" ];
                    unstagedChangesColor = [ "#e67e80" ];
                    defaultFgColor = [ "#d3c6aa" ];
                };
            };
        };
    };
}
