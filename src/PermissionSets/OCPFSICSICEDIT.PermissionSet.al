namespace OnlyCopilotFans.SicClassification;

permissionset 77078 "OCPFSIC SIC, EDIT"
{
    Assignable = true;
    Caption = 'SIC Code Classification - Edit';
    IncludedPermissionSets = "OCPFSIC SIC, VIEW";

    Permissions =
        tabledata "ocpfsicSicCode" = RIMD,
        codeunit "ocpfsicSicCodeImport" = X,
        page "ocpfsicSicCodeSetupWizard" = X;
}
