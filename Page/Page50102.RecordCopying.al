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
                field("Entity Code"; "Entity Code")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Entity Code';
                    ToolTip = 'Insert Entity Code to copy';
                }
                field("Table ID"; "Table ID")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Table ID';
                    ToolTip = 'Insert table no. to copy';
                }
                field("Table Name"; "Table Name")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Table Name';
                    ToolTip = 'Specify table name to copy';
                }
                field(Rank; Rank)
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Rank';
                    ToolTip = 'Specify rank table to copy';
                }
                field("DeleteAll Before"; "DeleteAll Before")
                {
                    ApplicationArea = All;
                    CaptionML = ENU = 'Delete All';
                    ToolTip = 'Specify delete all before copy';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Copy")
            {
                CaptionML = ENU = 'Copy',
                            RUS = 'Copy';

                action("START COPY RECORDS")
                {
                    CaptionML = ENU = 'Copy Records';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
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
                action(Worksheet)
                {
                    CaptionML = ENU = 'Worksheet';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Copy Record Worksheet");
                    end;

                }
            }
            group("Update")
            {
                CaptionML = ENU = 'Update',
                            RUS = 'Update';

                action("UpdateCustAgreement")
                {
                    CaptionML = ENU = 'Update Cust Agr';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.UpdateBCIdCustomerAgreement();
                    end;

                }
                action("UpdateDescriptinExtended")
                {
                    CaptionML = ENU = 'Update Descriptin Extended';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.UpdateDescriptinExtended();
                    end;

                }
                action("UpdateCustBankAcc")
                {
                    CaptionML = ENU = 'Update Cust Bank Acc';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
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
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.BlockDeduplCust();
                    end;

                }
                action("FixCustomersVATRegNo")
                {
                    CaptionML = ENU = 'Fix Customers VATRegNo';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.FixCustVATRegNoInHolding();
                    end;

                }
                action(RestartJobQueueReady)
                {
                    CaptionML = ENU = 'Restart Job Queue in Ready';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.RestartJobQueueInReady();
                    end;

                }
                action(RestartJobQueueError)
                {
                    CaptionML = ENU = 'Restart Job Queue in Error';
                    // Promoted = true;
                    // PromotedCategory = Process;
                    // PromotedIsBig = true;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        RecordCopyMgt: Codeunit "Record Copy Mgt.";
                    begin
                        RecordCopyMgt.RestartJobQueueInError();
                    end;

                }
            }
        }
    }
}