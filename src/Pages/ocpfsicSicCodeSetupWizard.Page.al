namespace OnlyCopilotFans.SicClassification;

page 77076 "ocpfsicSicCodeSetupWizard"
{
    PageType = NavigatePage;
    Caption = 'Import SIC Codes';

    layout
    {
        area(content)
        {
            group(Step1)
            {
                Visible = Step1Visible;
                Caption = 'Import SIC Codes';
                InstructionalText = 'This guide loads the full Standard Industrial Classification (SIC) code list, so it can be assigned to Customers. You can run it again later - existing codes are updated, not duplicated.';
            }
            group(Step2)
            {
                Visible = Step2Visible;
                Caption = 'Done';

                field(resultText; ResultText)
                {
                    Caption = 'Result';
                    ToolTip = 'Specifies the result of the SIC code import.';
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ActionImport)
            {
                Caption = 'Import';
                ToolTip = 'Loads the SIC code list.';
                ApplicationArea = All;
                Visible = Step1Visible;
                InFooterBar = true;
                Image = ImportExport;

                trigger OnAction()
                var
                    ImportedCount: Integer;
                    ResultLbl: Label 'Import complete. %1 SIC codes are ready to assign to customers.', Comment = '%1 = number of SIC codes imported';
                begin
                    ImportedCount := SicCodeImport.Import();
                    ResultText := StrSubstNo(ResultLbl, ImportedCount);
                    Step1Visible := false;
                    Step2Visible := true;
                end;
            }
            action(ActionFinish)
            {
                Caption = 'Finish';
                ToolTip = 'Closes this guide.';
                ApplicationArea = All;
                Visible = Step2Visible;
                InFooterBar = true;
                Image = Approve;

                trigger OnAction()
                begin
                    CurrPage.Close();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Step1Visible := true;
        Step2Visible := false;
    end;

    var
        SicCodeImport: Codeunit "ocpfsicSicCodeImport";
        ResultText: Text;
        Step1Visible: Boolean;
        Step2Visible: Boolean;
}
