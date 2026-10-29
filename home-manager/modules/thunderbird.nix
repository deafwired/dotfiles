{ ... }:
{
    # Accounts are added through Thunderbird's own setup wizard so the
    # address stays out of the repo.
    programs.thunderbird = {
        enable = true;
        profiles.default = {
            isDefault = true;
            settings = {
                "mail.shell.checkDefaultClient" = false;
            };
        };
    };
}
