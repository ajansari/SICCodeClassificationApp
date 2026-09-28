namespace OnlyCopilotFans.SicClassification;

using Microsoft.Sales.Customer;

pageextension 77074 "ocpfsicCustomerCardExt" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(ocpfsicSicClassification)
            {
                Caption = 'SIC Classification';

                field(ocpfsicSicCode; Rec."SIC Code")
                {
                    Caption = 'SIC Code';
                    ToolTip = 'Specifies the Standard Industrial Classification code assigned to this customer.';
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(ocpfsicSicCodeDescription; Rec."SIC Code Description")
                {
                    Caption = 'SIC Code Description';
                    ToolTip = 'Specifies the description of the SIC code assigned to this customer.';
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
}
