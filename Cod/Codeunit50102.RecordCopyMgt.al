codeunit 50102 "Record Copy Mgt."
{
    // Version BCGOLIVE -- DELETE TABLES FOR GO-LIVE (TRANSACTIONAL,ASSIGN YOUR TABLES)
    Permissions = TableData "Item Ledger Entry" = rimd, TableData "Value Entry" = rimd,
    TableData "G/L Entry" = rimd, TableData "Cust. Ledger Entry" = rimd,
    TableData "Vendor Ledger Entry" = rimd, TableData "Item Vendor" = rimd,
    TableData "G/L Register" = rimd, TableData "Item Register" = rimd,
    TableData "Sales Shipment Header" = rimd, TableData "Sales Shipment Line" = rimd,
    TableData "Sales Invoice Header" = rimd, TableData "Sales Invoice Line" = rimd,
    TableData "Sales Cr.Memo Header" = rimd, TableData "Sales Cr.Memo Line" = rimd,
    TableData "Purch. Rcpt. Header" = rimd, TableData "Purch. Rcpt. Line" = rimd,
    TableData "Purch. Inv. Header" = rimd, TableData "Purch. Inv. Line" = rimd,
    TableData "Purch. Cr. Memo Hdr." = rimd, TableData "Purch. Cr. Memo Line" = rimd,
    TableData "Reservation Entry" = rimd, TableData "Entry Summary" = rimd,
    TableData "Detailed Cust. Ledg. Entry" = rimd, TableData "Detailed Vendor Ledg. Entry" = rimd,
    TableData "Deferral Header" = rimd, TableData "Deferral Line" = rimd,
    TableData "Item Application Entry" = rimd,
    TableData "Production Order" = rimd, TableData "Prod. Order Line" = rimd,
    TableData "Prod. Order Component" = rimd, TableData "Prod. Order Routing Line" = rimd,
    TableData "Posted Deferral Header" = rimd, TableData "Posted Deferral Line" = rimd,
    TableData "Item Variant" = rimd, TableData "Unit of Measure Translation" = rimd,
    TableData "Item Unit of Measure" = rimd,
    TableData "Transfer Header" = rimd, TableData "Transfer Line" = rimd,
    TableData "Transfer Route" = rimd, TableData "Transfer Shipment Header" = rimd,
    TableData "Transfer Shipment Line" = rimd, TableData "Transfer Receipt Header" = rimd,
    TableData "Transfer Receipt Line" = rimd,
    TableData "Capacity Ledger Entry" = rimd, TableData "Lot No. Information" = rimd,
    TableData "Serial No. Information" = rimd, TableData "Item Entry Relation" = rimd,
    TableData "Return Shipment Header" = rimd, TableData "Return Shipment Line" = rimd,
    TableData "Return Receipt Header" = rimd, TableData "Return Receipt Line" = rimd,
    TableData "G/L Budget Entry" = rimd, TableData "Res. Capacity Entry" = rimd,
    TableData "Job Ledger Entry" = rimd, TableData "Res. Ledger Entry" = rimd,
    TableData "VAT Entry" = rimd, TableData "Document Entry" = rimd,
    TableData "Bank Account Ledger Entry" = rimd, TableData "Phys. Inventory Ledger Entry" = rimd,
    TableData "Approval Entry" = rimd, TableData "Posted Approval Entry" = rimd,
    TableData "Cost Entry" = rimd, TableData "Employee Ledger Entry" = rimd,
    // TableData "Detailed Employee Ledger Entry" = rimd, 
    TableData "FA Ledger Entry" = rimd,
    TableData "Maintenance Ledger Entry" = rimd, TableData "Service Ledger Entry" = rimd,
    TableData "Warranty Ledger Entry" = rimd, TableData "Item Budget Entry" = rimd,
    TableData "Production Forecast Entry" = rimd, TableData "Location" = rimd, TableData "Bin" = rimd,
    TableData "Customer" = rimd, TableData "Vendor" = rimd, TableData "Item" = rimd,
    TableData "Warehouse Entry" = rimd;//, TableData "Bank Directory" = rimd;
    //... ADD COUNTRY LOCALIZATION TABLES, FA, SERVICE etc. etc.

    trigger OnRun()
    begin
    end;

    var
        Text0001: Label 'Copy Records to All Holding?';
        Text0002: Label 'Copying Records!\Delete All: #3######\Company: #2########\Table: #1#######';
        Text0003: Label 'Blocking Customers!\Company: #1########\Customer: #2#######';

    procedure CopyRecords(var RecordCopyTable: Record "Record Copy Table")
    var
        Window: Dialog;
        RecRefFrom: RecordRef;
        RecRefTo: RecordRef;
        IntegrationCompany: Record "Company Integration";
    begin
        CheckCompanyFrom();

        if not Confirm(Text0001, false) then
            exit;

        Window.Open(Text0002);

        RecordCopyTable.SetCurrentKey(Rank);
        IntegrationCompany.SetRange("Copy Items To", true);
        if IntegrationCompany.FindSet(false, false) then
            repeat
                Window.Update(2, IntegrationCompany."Company Name");
                if RecordCopyTable.FindSet(false, false) then
                    repeat
                        Window.Update(1, Format(RecordCopyTable."Table ID"));
                        RecRefFrom.Open(RecordCopyTable."Table ID", false, CompanyName);
                        RecRefTo.Open(RecordCopyTable."Table ID", false, IntegrationCompany."Company Name");
                        Window.Update(3, Format(RecordCopyTable."DeleteAll Before"));
                        if RecordCopyTable."DeleteAll Before" then
                            RecRefTo.DeleteAll();
                        if RecRefFrom.FindSet(false, false) then
                            repeat
                                if RecRefToFindRec(RecRefTo, RecRefFrom) then begin
                                    CopyRecord(RecRefTo, RecRefFrom);
                                    RecRefTo.Modify();
                                end else begin
                                    CopyRecord(RecRefTo, RecRefFrom);
                                    RecRefTo.Insert();
                                end;
                            until RecRefFrom.Next() = 0;
                        RecRefTo.Close();
                        RecRefFrom.Close;
                    until RecordCopyTable.Next = 0;
            until IntegrationCompany.Next() = 0;

        Window.Close;
    end;

    local procedure CheckCompanyFrom()
    var
        IntegrationCompany: Record "Company Integration";
    begin
        IntegrationCompany.SetRange("Company Name", CompanyName);
        IntegrationCompany.FindFirst();
        IntegrationCompany.TestField("Copy Items From", true);
    end;

    local procedure CopyRecord(var RecRefTo: RecordRef; var RecRefFrom: RecordRef)
    var
        locField: Record Field;
    begin
        locField.SetCurrentKey(Enabled, Class);
        locField.SetRange(TableNo, RecRefFrom.NUMBER);
        locField.SetRange(Enabled, TRUE);
        locField.SetRange(ObsoleteState, locField.ObsoleteState::No);
        locField.SetRange(Class, locField.Class::Normal);
        IF locField.FindSet(false, false) THEN
            REPEAT
                if locField.Type = locField.Type::BLOB then
                    RecRefFrom.FIELD(locField."No.").CalcField();
                RecRefTo.FIELD(locField."No.").Value := RecRefFrom.FIELD(locField."No.").Value;
            UNTIL locField.NEXT = 0;
    end;

    local procedure RecRefToFindRec(RecRefTo: RecordRef; RecRefFrom: RecordRef): Boolean
    var
        locField: Record Field;
    begin
        locField.SetCurrentKey(Enabled, IsPartOfPrimaryKey);
        locField.SetRange(TableNo, RecRefFrom.NUMBER);
        locField.SetRange(Enabled, TRUE);
        locField.SetRange(IsPartOfPrimaryKey, true);
        if locField.FindSet(false, false) then begin
            repeat
                RecRefTo.Field(locField."No.").SetRange(RecRefFrom.Field(locField."No.").Value);
            until locField.NEXT = 0;

            exit(RecRefTo.FindFirst());
        end;
        exit(false);
    end;

    procedure UpdateBankAccounts()
    begin
        UpdateCurrencyCodeCustomerBankAccounts();
    end;

    procedure UpdateCurrencyCodeCustomerBankAccounts()
    var
        Window: Dialog;
        CustomerBankAccount: Record "Customer Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        IntegrationCompany: Record "Company Integration";
        GLSetup: Record "General Ledger Setup";
        Integration1C: Codeunit "Integration 1C";
    begin
        CheckCompanyFrom();

        if not Confirm(Text0001, false) then
            exit;

        Window.Open(Text0002);

        if IntegrationCompany.FindSet(false, false) then
            repeat
                Window.Update(1, CustomerBankAccount.TableCaption);
                Window.Update(2, IntegrationCompany."Company Name");
                CustomerBankAccount.ChangeCompany(IntegrationCompany."Company Name");
                VendorBankAccount.ChangeCompany(IntegrationCompany."Company Name");
                GLSetup.ChangeCompany(IntegrationCompany."Company Name");
                GLSetup.Get();

                // update Bank Directory
                Integration1C.UpdateBankDirectoryByCompany(IntegrationCompany."Company Name");

                // update Currency Code
                CustomerBankAccount.SetFilter("Currency Code", '');
                CustomerBankAccount.ModifyAll("Currency Code", GLSetup."LCY Code");

                VendorBankAccount.SetFilter("Currency Code", '');
                VendorBankAccount.ModifyAll("Currency Code", GLSetup."LCY Code");
            until IntegrationCompany.Next() = 0;

        Window.Close;
    end;

    procedure BlockDeduplCust()
    var
        Customer: Record Customer;
        blockCustomer: Record Customer;
        Window: Dialog;
        IntegrationCompany: Record "Company Integration";
        blanckGuid: Guid;
    begin
        CheckCompanyFrom();
        if not Confirm(Text0001, false) then
            exit;
        Window.Open(Text0003);
        if IntegrationCompany.FindSet(false, false) then
            repeat
                Window.Update(1, IntegrationCompany."Company Name");
                Customer.ChangeCompany(IntegrationCompany."Company Name");
                blockCustomer.ChangeCompany(IntegrationCompany."Company Name");

                // block deduplicated customer
                Customer.SetCurrentKey("No.", "Deduplicate Id", Blocked);
                Customer.SetFilter("Deduplicate Id", '<>%1', blanckGuid);
                Customer.SetFilter(Blocked, '<>%1', Customer.Blocked::All);
                if Customer.FindSet(true, false) then
                    repeat
                        Customer.CalcFields("Balance (LCY)");
                        if Customer."Balance (LCY)" = 0 then begin
                            Window.Update(2, Customer."No.");
                            blockCustomer.Get(Customer."No.");
                            blockCustomer.Blocked := blockCustomer.Blocked::All;
                            blockCustomer.Modify()
                        end;
                    until Customer.Next() = 0;
            until IntegrationCompany.Next() = 0;
        Window.Close;
    end;
}