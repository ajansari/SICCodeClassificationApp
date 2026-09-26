namespace OnlyCopilotFans.SicClassification;

using System.Environment.Configuration;
using System.Media;
using System.Reflection;

codeunit 77075 "ocpfsicSicCodeImport"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Guided Experience", 'OnRegisterAssistedSetup', '', false, false)]
    local procedure OnRegisterAssistedSetup()
    var
        GuidedExperience: Codeunit "Guided Experience";
        GuidedExperienceType: Enum "Guided Experience Type";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
        TitleLbl: Label 'Import SIC Codes';
        ShortTitleLbl: Label 'Import SIC codes';
        DescriptionLbl: Label 'Loads the full Standard Industrial Classification code list, ready to assign to Customers.';
    begin
        if GuidedExperience.Exists(GuidedExperienceType::"Assisted Setup", ObjectType::Page, Page::"ocpfsicSicCodeSetupWizard") then
            exit;

        GuidedExperience.InsertAssistedSetup(
            TitleLbl,
            ShortTitleLbl,
            DescriptionLbl,
            1,
            ObjectType::Page,
            Page::"ocpfsicSicCodeSetupWizard",
            AssistedSetupGroup::Uncategorized,
            '',
            VideoCategory::Uncategorized,
            '');
    end;

    procedure Import(): Integer
    var
        TypeHelper: Codeunit "Type Helper";
        ResourceContent: Text;
        Lines: List of [Text];
        LineText: Text;
        LineNo: Integer;
        ImportedCount: Integer;
    begin
        ResourceContent := NavApp.GetResourceAsText('SicCodes.txt', TextEncoding::UTF8);
        Lines := ResourceContent.Split(TypeHelper.CRLFSeparator(), TypeHelper.LFSeparator());

        for LineNo := 1 to Lines.Count() do begin
            LineText := Lines.Get(LineNo);
            if (LineNo > 1) and (LineText <> '') then
                if ImportLine(LineText) then
                    ImportedCount += 1;
        end;

        exit(ImportedCount);
    end;

    local procedure ImportLine(LineText: Text): Boolean
    var
        SicCode: Record "ocpfsicSicCode";
        Fields: List of [Text];
        DivisionCode: Code[1];
        IsNew: Boolean;
    begin
        Fields := LineText.Split('|');
        if Fields.Count() <> 5 then
            exit(false);

        DivisionCode := CopyStr(Fields.Get(1), 1, 1);
        IsNew := not SicCode.Get(CopyStr(Fields.Get(4), 1, 4));
        if IsNew then
            SicCode.Init();

        SicCode.Code := CopyStr(Fields.Get(4), 1, 4);
        SicCode.Description := CopyStr(Fields.Get(5), 1, 150);
        SicCode."Division Code" := DivisionCode;
        SicCode."Major Group Code" := CopyStr(Fields.Get(2), 1, 2);
        SicCode."Industry Group Code" := CopyStr(Fields.Get(3), 1, 3);

        if IsNew or not SicCode."Division Name Overridden" then
            SicCode."Division Name" := GetDivisionName(DivisionCode);

        if IsNew then
            SicCode.Insert()
        else
            SicCode.Modify();

        exit(true);
    end;

    local procedure GetDivisionName(DivisionCode: Code[1]): Text[100]
    begin
        case DivisionCode of
            'A':
                exit('Agriculture, Forestry, And Fishing');
            'B':
                exit('Mining');
            'C':
                exit('Construction');
            'D':
                exit('Manufacturing');
            'E':
                exit('Transportation, Communications, Electric, Gas, And Sanitary Services');
            'F':
                exit('Wholesale Trade');
            'G':
                exit('Retail Trade');
            'H':
                exit('Finance, Insurance, And Real Estate');
            'I':
                exit('Services');
            'J':
                exit('Public Administration');
            else
                exit('');
        end;
    end;
}
