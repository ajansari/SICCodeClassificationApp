namespace OnlyCopilotFans.SicClassification;

page 77081 "ocpfsicSicCodeApi"
{
    PageType = API;
    APIPublisher = 'onlyCopilotFans';
    APIGroup = 'ocpfsicClassification';
    APIVersion = 'v1.0';
    EntityName = 'ocpfsicSicCode';
    EntitySetName = 'ocpfsicSicCodes';
    SourceTable = "ocpfsicSicCode";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    Caption = 'Represents an entry in the Standard Industrial Classification (SIC) code list, the U.S. Department of Labor''s 1987 industry classification hierarchy.';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(systemId; Rec.SystemId)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
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
                field(customerCount; Rec."Customer Count")
                {
                    Caption = 'Customer Count';
                    ToolTip = 'Specifies how many customers are assigned this SIC code.';
                    ApplicationArea = All;
                }
            }
        }
    }
}
