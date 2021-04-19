table 50102 "Record Copy Table"
{
    // version BCGOLIVE
    fields
    {
        field(1; "Table ID"; Integer)
        {
            Editable = true;  //INSERT TABLE No.
        }
        field(2; "Table Name"; Text[250])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup(AllObjWithCaption."Object Name" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
            Editable = false;
        }
        field(5; "Copy Records"; Boolean)
        {
        }
        field(6; Company; Text[30])
        {
        }
        field(7; "DeleteAll Before"; Boolean)
        {
        }
        field(8; Rank; Integer)
        {
        }
        field(9; "Entity Code"; Code[20])
        {
            TableRelation = "Entity Clone";
        }
    }

    keys
    {
        key(Key1; "Entity Code", "Table ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Company := CompanyName;
    end;
}