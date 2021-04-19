page 50103 "Entity Clone List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Entity Clone";
    InsertAllowed = True;
    Editable = True;
    UsageCategory = Tasks;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;

                }
                field(Desciption; Desciption)
                {
                    ApplicationArea = All;

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

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}