page 50104 "Copy Record Worksheet"
{
    PageType = Card;
    ApplicationArea = Basic, Suit;
    UsageCategory = Tasks;
    // SourceTable = "Entity Clone";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                CaptionML = ENU = 'Copy Record Worksheet';
                field(CodeFilter; CodeFilter)
                {
                    ApplicationArea = Basic, Suit;
                    CaptionML = ENU = 'Code Filter';
                    ToolTip = 'Specified Code Filter to copy';
                    TableRelation = "Entity Clone";
                }
                field(flgDeleteAll; flgDeleteAll)
                {
                    ApplicationArea = Basic, Suit;
                    CaptionML = ENU = 'Delete All';
                    ToolTip = 'Specified Delete All before copy';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Clone';
                ToolTip = 'Clone records from current company to holding';

                trigger OnAction()
                begin
                    RecordCopyMgt.CopyRecordsByCodeFilter(CodeFilter, flgDeleteAll);
                end;
            }
        }
    }

    var
        RecordCopyMgt: Codeunit "Record Copy Mgt.";
        CodeFilter: Code[30];
        flgDeleteAll: Boolean;
}