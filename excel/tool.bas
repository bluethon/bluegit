Option Explicit
Option Base 1

Public Rootdatafile As String, Value As String
Public Template As Worksheet, TmplRange As Range
Public UpldSheet As Worksheet, LoadRange As Range
Public raw_last As Integer, col_last As Integer
Public wkBook As Object, ws As Object

'Public fileName As String   '�����ļ�������ļ���
Public PlmOutputName As String
Public PlmBomAddFile As String
Public PlmImGroupName As String

Sub Data_Copy()

Dim Point As Long

Set TmplRange = Template.Cells(1, 1).CurrentRegion
Set UpldSheet = wkBook.Worksheets("upload")
Set LoadRange = UpldSheet.Cells(1, 1).CurrentRegion

Point = LoadRange.Rows.Count
If Point = 1 Then
TmplRange.Copy Destination:=UpldSheet.Cells(Point, 1)
Else
TmplRange.Copy Destination:=UpldSheet.Cells(Point + 1, 1)
End If

End Sub
Sub Template_sap()

Dim shtcount As Integer
Dim currow As Integer, curcol As Integer

On Error GoTo Endline
'����ǰ�������ֱ�Ӹ�ֵ
Set wkBook = ActiveWorkbook
Set Template = wkBook.Worksheets("template")

shtcount = 0
If Worksheets.Count < 3 Then
    Exit Sub
End If

For Each ws In wkBook.Worksheets
    If UCase(ws.name) = "TEMPLATE" Then
        shtcount = shtcount + 1
    End If
    If UCase(ws.name) = "RAWDATA" Then
        shtcount = shtcount + 1
    End If
     If UCase(ws.name) = "UPLOAD" Then
        shtcount = shtcount + 1
    End If
Next ws
'��֤���������
If shtcount < 3 Then
Endline:
    MsgBox "The data file must contain : " & Chr(13) & _
           " one batch input template sheet with name 'TEMPLATE'" & Chr(13) & _
           " and one sheet with name 'RAWDATA' and one with name 'upload'"
    Exit Sub
End If

With ActiveSheet
raw_last = .Cells(.Rows.Count, "A").End(xlUp).Row
col_last = .Cells(1, .Columns.Count).End(xlToLeft).Column
End With

currow = 3
curcol = 2

With wkBook.Worksheets("rawdata")
Do While (currow <= raw_last)
    For curcol = 1 To col_last
    If Not IsEmpty(.Cells(2, curcol)) Then
        Value = .Cells(currow, curcol).Value
        Template.Cells(.Cells(2, curcol).Value, 5).Value = Value
    End If
    Next curcol
    Application.StatusBar = "processing line: " & currow - 2
    Call Data_Copy
    currow = currow + 1
Loop

wkBook.Worksheets("upload").Activate
ActiveSheet.Cells(1, 1).CurrentRegion.Select

End With

'����ǰ�ĵ�·��+txt�ļ���ֵ
Rootdatafile = wkBook.Path + "\bdc_recording.txt"
'���txt�ļ�����,ɾ��֮,��ֹ�������ǶԻ���
If Dir(Rootdatafile) <> "" Then
    '��ʾ���txt�ļ�·��
    'MsgBox Rootdatafile
    Kill (Rootdatafile)
Else: MsgBox "�ļ�������"
End If

ActiveWorkbook.SaveAs fileName:=(Rootdatafile), FileFormat:=xlText
ActiveWorkbook.Close SaveChanges:=False

End Sub
Sub Template_plm(name As String)

Dim firstrng As Range

With ActiveSheet
raw_last = .Cells(.Rows.Count, "A").End(xlUp).Row
col_last = .Cells(6, .Columns.Count).End(xlToLeft).Column

If .Cells(1).Value = "ImportSheetType=PART" Then
    Set firstrng = .Cells.Find("End Item", LookIn:=xlValues, lookat:=xlWhole, MatchCase:=False).Offset(1, 0)
ElseIf .Cells(1).Value = "ImportSheetType=BOM" Then
    Set firstrng = .Cells.Find("Action", LookIn:=xlValues, lookat:=xlWhole, MatchCase:=False).Offset(1, 0)
Else
    MsgBox "Type���Ͳ���"
    Exit Sub
End If

End With

With Range(firstrng, Cells(raw_last, col_last))
    If raw_last > firstrng.Row Then
        .FillDown
    End If
     'ȥ��ʽ
    .Value = .Value
End With

Call SaveFile(name)

End Sub
Sub E_26(name As String)
'Auto transform E part and 26 part to BOM
Dim rn, i As Integer
Dim arr As Variant

    rn = Range("A65535").End(xlUp).Row
    arr = Array(0, 1)
    [A1].Select
    For i = 1 To rn
        ActiveCell.Offset(1, 0).Rows("1:1").EntireRow.Insert Shift:=xlDown
        ActiveCell.Offset(0, 2).Resize(1, 2).Cut ActiveCell.Offset(1, 0)
        ActiveCell.Offset(2, 0).Select
    Next
    Columns("A:A").Insert Shift:=xlToRight
    Range("A1:A2") = Application.WorksheetFunction.Transpose(arr)
    rn = Range("B65535").End(xlUp).Row
    Range("A1:A2").AutoFill Range("A1").Resize(rn, 1), xlFillCopy
    [A1].CurrentRegion.Columns.AutoFit
    arr = [A1].CurrentRegion

    Workbooks.Open (name)
    With ActiveWorkbook.Worksheets(1)
        .Cells(7, 1).Resize(UBound(arr), 3) = arr
    End With

End Sub
Sub plm_imgroup(name As String)
Dim rn As Integer


    '������˳��
    [K:K].Cut
    [A:A].Insert Shift:=xlToRight
    [K:K].Cut
    [C:C].Insert Shift:=xlToRight
    [F:G].Cut
    [D:D].Insert Shift:=xlToRight

    '���������
    With ActiveSheet
        rn = .Cells(.Rows.Count, "B").End(xlUp).Row
        .Range("A2") = Range("A2").Value
        .Range("D2") = "��"
        .Range("E2") = "��"
        .Range("A2", .Cells(rn, "A")).FillDown
        .Range("D2", .Cells(rn, "E")).FillDown
    End With

    '����
    Call SaveFile(name)

End Sub
Sub AddToWorkNote(WorkNote As String)

Dim wb As Workbook
Dim sht As Worksheet

Dim tbl As Range
Dim arr As Variant

Dim endRow As Integer
Dim numRows As Integer
Dim numColumns As Integer

    If Len(Dir(WorkNote)) > 0 Then

        With ActiveSheet
            Set tbl = .Cells(1, 1).CurrentRegion

            numRows = tbl.Rows.Count
            numColumns = tbl.Columns.Count

            arr = tbl.Offset(1, 0).Resize(numRows - 1, numColumns - 1).Value
        End With

        Workbooks.Open (WorkNote)
        Set wb = ActiveWorkbook
        Set sht = wb.Worksheets("����·��")
        endRow = sht.Cells(sht.Rows.Count, "C").End(xlUp).Row

        With sht.Cells(endRow + 1, 1)
            If .Address = "$A$2" Then
                .Value = 1
            Else
                .Value = .Offset(-1, 0) + 1
            End If
            .Offset(0, 1).Value = Date

            .AutoFill .Resize(UBound(arr, 1), 1), xlFillSeries
            .Offset(0, 1).AutoFill .Offset(0, 1).Resize(UBound(arr, 1), 1), xlFillCopy
            .Offset(0, 2).Resize(UBound(arr, 1), UBound(arr, 2)) = arr
        End With
        wb.Close (True)

    Else
        MsgBox "������¼������, δ��ӳɹ�"
    End If

End Sub
Sub SaveFile(name As String)

    Application.DisplayAlerts = False
    With ActiveWorkbook
        .SaveCopyAs ("D:\baiduyun\Dropbox\SF\�浵\��������\" + Format(Now, "YYYYMMDD-HHMM_") + .name)
        .SaveAs (name)
        .Close (False)
    End With
    Application.DisplayAlerts = True

End Sub
Sub main()

Dim fileName As String
Dim PlmImOptionSet As String
Dim PlmImBomExpression As String
Dim PlmPart2CAD As String
Dim ZPP78_Name As String
Dim WorkNote As String
Dim awbName As String
Dim awbPath As String

'init
PlmOutputName = "\000_import_plm"
PlmImGroupName = "\005_import_Group"
PlmImOptionSet = "\006_import_OptionSet"
PlmImBomExpression = "\007_import_BomExpression"
PlmPart2CAD = "\008_import_Parts2CAD"
PlmBomAddFile = "\021_BOM_import-add.xlsx"

ZPP78_Name = "D:\������������·�߹���"
WorkNote = "D:\baiduyun\Dropbox\SF\������¼.xlsx"

awbName = ActiveWorkbook.name
awbPath = ActiveWorkbook.Path

Application.ScreenUpdating = False

'PLMģ��
If ActiveSheet.Cells(1, 1) Like "*ImportSheetType*" Then
    fileName = awbPath + PlmOutputName
    Call Template_plm(fileName)

'E-26BOMת��
ElseIf awbName Like "*E-26*" Then
    fileName = awbPath + PlmBomAddFile
    Call E_26(fileName)
    fileName = awbPath + PlmOutputName
    Call Template_plm(fileName)
    ActiveWorkbook.Close SaveChanges:=False

'ZPP78 ����·��
ElseIf awbName Like "*ZPP78*" Then
    fileName = ZPP78_Name
    Call AddToWorkNote(WorkNote)
    Call SaveFile(fileName)

'����ѡ����
ElseIf awbName Like "*import_Group*" Then
    fileName = awbPath + PlmImGroupName
    Call plm_imgroup(fileName)

'����ѡ�
ElseIf awbName Like "*import_OptionSet*" Then
    fileName = awbPath + PlmImOptionSet
    Call SaveFile(fileName)

'������ʽ
ElseIf awbName Like "*import_BomExpression*" Then
    fileName = awbPath + PlmImBomExpression
    Call SaveFile(fileName)

'B������CADͼֽ����
ElseIf awbName Like "*CAD*" Then

    '���������
    With ActiveSheet.Range("C2")
        .Value = "E"
        .AutoFill .Resize(ActiveSheet.Cells(ActiveSheet.Rows.Count, "B").End(xlUp).Row - 1, 1), xlFillCopy
    End With

    fileName = awbPath + PlmPart2CAD
    Call SaveFile(fileName)

Else
    Call Template_sap
End If

Application.ScreenUpdating = True

End Sub
