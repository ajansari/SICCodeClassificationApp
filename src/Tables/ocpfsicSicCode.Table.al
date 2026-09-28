namespace OnlyCopilotFans.SicClassification;

using Microsoft.Sales.Customer;

table 77071 "ocpfsicSicCode"
{
    Caption = 'SIC Code';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Code; Code[4])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[150])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Division Code"; Code[1])
        {
            Caption = 'Division Code';
            DataClassification = CustomerContent;
        }
        field(4; "Division Name"; Text[100])
        {
            Caption = 'Division Name';
            DataClassification = CustomerContent;
        }
        field(5; "Major Group Code"; Code[2])
        {
            Caption = 'Major Group Code';
            DataClassification = CustomerContent;
        }
        field(6; "Industry Group Code"; Code[3])
        {
            Caption = 'Industry Group Code';
            DataClassification = CustomerContent;
        }
        field(7; "Division Name Overridden"; Boolean)
        {
            Caption = 'Division Name Overridden';
            DataClassification = SystemMetadata;
        }
        field(8; "Customer Count"; Integer)
        {
            Caption = 'Customer Count';
            FieldClass = FlowField;
            CalcFormula = count(Customer where("SIC Code" = field(Code)));
            Editable = false;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        Customer: Record Customer;
        DeleteBlockedErr: Label 'You can''t delete SIC Code %1 because it''s assigned to at least one customer.', Comment = '%1 = SIC Code';
    begin
        Customer.SetRange("SIC Code", Rec.Code);
        if not Customer.IsEmpty() then
            Error(DeleteBlockedErr, Rec.Code);
    end;
}
