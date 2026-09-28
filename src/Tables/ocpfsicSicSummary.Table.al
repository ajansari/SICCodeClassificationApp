namespace OnlyCopilotFans.SicClassification;

table 77079 "ocpfsicSicSummary"
{
    Caption = 'SIC Code Summary';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; Level; Option)
        {
            Caption = 'Level';
            OptionMembers = Division,"Major Group","Industry Group";
        }
        field(2; "Group Code"; Code[3])
        {
            Caption = 'Group Code';
        }
        field(3; "Group Name"; Text[100])
        {
            Caption = 'Group Name';
        }
        field(4; "Customer Count"; Integer)
        {
            Caption = 'Customer Count';
        }
    }

    keys
    {
        key(PK; Level, "Group Code")
        {
            Clustered = true;
        }
    }
}
