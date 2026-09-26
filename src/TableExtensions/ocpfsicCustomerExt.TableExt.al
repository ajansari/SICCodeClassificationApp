namespace OnlyCopilotFans.SicClassification;

using Microsoft.Sales.Customer;

tableextension 77073 "ocpfsicCustomerExt" extends Customer
{
    fields
    {
        field(77090; "SIC Code"; Code[4])
        {
            Caption = 'SIC Code';
            DataClassification = CustomerContent;
            TableRelation = "ocpfsicSicCode".Code;
        }
        field(77091; "SIC Code Description"; Text[150])
        {
            Caption = 'SIC Code Description';
            FieldClass = FlowField;
            CalcFormula = lookup("ocpfsicSicCode".Description where(Code = field("SIC Code")));
            Editable = false;
        }
    }
}
