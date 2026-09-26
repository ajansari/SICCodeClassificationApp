namespace OnlyCopilotFans.SicClassification;

permissionset 77077 "OCPFSIC SIC, VIEW"
{
    Assignable = true;
    Caption = 'SIC Code Classification - View';

    Permissions =
        tabledata "ocpfsicSicCode" = R,
        page "ocpfsicSicCodes" = X;
}
