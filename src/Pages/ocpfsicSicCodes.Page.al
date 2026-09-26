namespace OnlyCopilotFans.SicClassification;

page 77072 "ocpfsicSicCodes"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "ocpfsicSicCode";
    Caption = 'SIC Codes';
    DelayedInsert = true;
    SourceTableView = sorting(Code);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(code; Rec.Code)
                {
                    Caption = 'Code';
                    ToolTip = 'Specifies the 4-digit SIC industry code.';
                    ApplicationArea = All;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                    ToolTip = 'Specifies the official description of this SIC industry.';
                    ApplicationArea = All;
                }
                field(divisionCode; Rec."Division Code")
                {
                    Caption = 'Division Code';
                    ToolTip = 'Specifies the SIC division letter (A-J) this code belongs to.';
                    ApplicationArea = All;
                }
                field(divisionName; Rec."Division Name")
                {
                    Caption = 'Division Name';
                    ToolTip = 'Specifies the name of the SIC division this code belongs to.';
                    ApplicationArea = All;
                }
                field(majorGroupCode; Rec."Major Group Code")
                {
                    Caption = 'Major Group Code';
                    ToolTip = 'Specifies the 2-digit SIC major group code this code belongs to.';
                    ApplicationArea = All;
                }
                field(industryGroupCode; Rec."Industry Group Code")
                {
                    Caption = 'Industry Group Code';
                    ToolTip = 'Specifies the 3-digit SIC industry group code this code belongs to.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
