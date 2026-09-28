namespace OnlyCopilotFans.SicClassification;

using Microsoft.Sales.Customer;

page 77080 "ocpfsicSicSummary"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'SIC Code Summary';
    SourceTable = "ocpfsicSicSummary";
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(groupCode; Rec."Group Code")
                {
                    Caption = 'Code';
                    ToolTip = 'Specifies the code of this group at the selected level.';
                    ApplicationArea = All;
                }
                field(groupName; Rec."Group Name")
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of this group, when one is recorded at the selected level.';
                    ApplicationArea = All;
                }
                field(customerCount; Rec."Customer Count")
                {
                    Caption = 'Customer Count';
                    ToolTip = 'Specifies how many customers fall under this group.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ActionByDivision)
            {
                Caption = 'By Division';
                ToolTip = 'Shows customer counts grouped by SIC division.';
                ApplicationArea = All;
                Image = Category;
                InFooterBar = true;

                trigger OnAction()
                begin
                    BuildSummary(Rec.Level::Division);
                end;
            }
            action(ActionByMajorGroup)
            {
                Caption = 'By Major Group';
                ToolTip = 'Shows customer counts grouped by SIC major group.';
                ApplicationArea = All;
                Image = Category;
                InFooterBar = true;

                trigger OnAction()
                begin
                    BuildSummary(Rec.Level::"Major Group");
                end;
            }
            action(ActionByIndustryGroup)
            {
                Caption = 'By Industry Group';
                ToolTip = 'Shows customer counts grouped by SIC industry group.';
                ApplicationArea = All;
                Image = ItemGroup;
                InFooterBar = true;

                trigger OnAction()
                begin
                    BuildSummary(Rec.Level::"Industry Group");
                end;
            }
        }
        area(Processing)
        {
            action(ActionShowCustomers)
            {
                Caption = 'Customers';
                ToolTip = 'Shows the customers in this group.';
                ApplicationArea = All;
                Image = Customer;

                trigger OnAction()
                begin
                    ShowCustomers();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        BuildSummary(Rec.Level::Division);
    end;

    local procedure BuildSummary(NewLevel: Option Division,"Major Group","Industry Group")
    var
        SicCode: Record "ocpfsicSicCode";
        NewGroupCode: Code[3];
        NewGroupName: Text[100];
    begin
        Rec.Reset();
        Rec.DeleteAll();

        SicCode.SetAutoCalcFields("Customer Count");
        if SicCode.FindSet() then
            repeat
                case NewLevel of
                    NewLevel::Division:
                        begin
                            NewGroupCode := SicCode."Division Code";
                            NewGroupName := SicCode."Division Name";
                        end;
                    NewLevel::"Major Group":
                        begin
                            NewGroupCode := SicCode."Major Group Code";
                            NewGroupName := '';
                        end;
                    NewLevel::"Industry Group":
                        begin
                            NewGroupCode := SicCode."Industry Group Code";
                            NewGroupName := '';
                        end;
                end;

                if Rec.Get(NewLevel, NewGroupCode) then begin
                    Rec."Customer Count" += SicCode."Customer Count";
                    Rec.Modify();
                end else begin
                    Rec.Init();
                    Rec.Level := NewLevel;
                    Rec."Group Code" := NewGroupCode;
                    Rec."Group Name" := NewGroupName;
                    Rec."Customer Count" := SicCode."Customer Count";
                    Rec.Insert();
                end;
            until SicCode.Next() = 0;

        Rec.Reset();
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    local procedure ShowCustomers()
    var
        SicCode: Record "ocpfsicSicCode";
        Customer: Record Customer;
    begin
        case Rec.Level of
            Rec.Level::Division:
                SicCode.SetRange("Division Code", Rec."Group Code");
            Rec.Level::"Major Group":
                SicCode.SetRange("Major Group Code", Rec."Group Code");
            Rec.Level::"Industry Group":
                SicCode.SetRange("Industry Group Code", Rec."Group Code");
        end;

        Customer.Reset();
        if SicCode.FindSet() then
            repeat
                Customer.SetRange("SIC Code", SicCode.Code);
                if Customer.FindSet() then
                    repeat
                        Customer.Mark(true);
                    until Customer.Next() = 0;
            until SicCode.Next() = 0;

        Customer.Reset();
        Customer.MarkedOnly(true);
        Page.Run(Page::"Customer List", Customer);
    end;
}
