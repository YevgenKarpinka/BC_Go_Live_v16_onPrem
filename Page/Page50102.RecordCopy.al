page 50102 "Record Copying"
{
    // version BCGOLIVE
    InsertAllowed = True; //Add records
    PageType = List;
    Editable = True;
    SourceTable = "Record Copy Table";
    UsageCategory = Tasks;  //show in the Search Menù - "Record Copy page"
    //AccessByPermission = page "Record Copy" = X;  //permissions for Page
    AccessByPermission = tabledata "Record Copy Table" = RIMD; //ALL permissions for Table
    ApplicationArea = All;
    CaptionML = ENU = 'Record Copy';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Table ID';
                    ToolTip = 'Insert table no. to Copy';
                }
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Table Name';
                    ToolTip = 'Specify table name to Copy';
                }
                field(Rank; Rank)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Table Name';
                    ToolTip = 'Specify rank table to Copy';
                }
                field("DeleteAll Before"; "DeleteAll Before")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'DeleteAll Before';
                    ToolTip = 'Specify delete all before Copy';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("START COPY RECORDS")
            {
                CaptionML = ENU = 'Copy Selected Records';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecCopy: Record "Record Copy Table";
                    RecordCopyMgt: Codeunit "Record Copy Mgt.";
                begin
                    CurrPage.SetSelectionFilter(RecCopy);
                    RecordCopyMgt.CopyRecords(RecCopy); //START COPY RECORDS
                end;

            }
            action("UpdateCustBankAcc")
            {
                CaptionML = ENU = 'Update Cust Bank Acc';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecordCopyMgt: Codeunit "Record Copy Mgt.";
                begin
                    RecordCopyMgt.UpdateBankAccounts();
                end;

            }
            action("BlockDeduplCust")
            {
                CaptionML = ENU = 'Block Deduplicated Customers';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    RecordCopyMgt: Codeunit "Record Copy Mgt.";
                begin
                    RecordCopyMgt.BlockDeduplCust();
                end;

            }
        }
    }
}