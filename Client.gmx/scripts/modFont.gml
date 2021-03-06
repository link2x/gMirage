Option Explicit

' ******************************************
' **            Mirage Source 4           **
' ** GDI text drawing                     **
' ******************************************

' Text declares
Private Declare Function CreateFont Lib "gdi32.dll" Alias "CreateFontA" (ByVal H As Long, ByVal W As Long, ByVal E As Long, ByVal O As Long, ByVal W As Long, ByVal i As Long, ByVal u As Long, ByVal s As Long, ByVal C As Long, ByVal OP As Long, ByVal CP As Long, ByVal Q As Long, ByVal PAF As Long, ByVal f As String) As Long
Private Declare Function SetBkMode Lib "gdi32.dll" (ByVal hdc As Long, ByVal nBkMode As Long) As Long
Private Declare Function SetTextColor Lib "gdi32.dll" (ByVal hdc As Long, ByVal crColor As Long) As Long
Private Declare Function TextOut Lib "gdi32.dll" Alias "TextOutA" (ByVal hdc As Long, ByVal X As Long, ByVal Y As Long, ByVal lpString As String, ByVal nCount As Long) As Long
Private Declare Function SelectObject Lib "gdi32.dll" (ByVal hdc As Long, ByVal hObject As Long) As Long

' Font variables
Private Const FONT_NAME As String = "fixedsys"
Private Const FONT_SIZE As Byte = 18

' Text variables
Public TexthDC As Long
Private MainFont As Long

' Draw map name location
Public DrawMapNameX As Single
Public DrawMapNameY As Single
Public DrawMapNameColor As Long

' Used to check if text needs to be drawn
Public BFPS As Boolean ' FPS
Public BLoc As Boolean ' map, player, and mouse location

' Quote character variable
Public vbQuote As String ' container for "
' Public Const vbQuote As String = """"

Public Sub InitFont()
    Call SetFont(MainFont, FONT_NAME, FONT_SIZE)
End Sub

Private Sub SetFont(ByRef Font As Long, ByVal FontName As String, ByVal FontSize As Byte)
    Font = CreateFont(FontSize, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, FontName)
End Sub

' Draw text onto buffer
Public Sub DrawText(ByVal hdc As Long, ByVal X, ByVal Y, ByVal Text As String, Color As Long)
    
    ' Selects an object into the specified DC.
    ' The new object replaces the previous object of the same type.
    Call SelectObject(hdc, MainFont)
    
    ' Sets the background mix mode of the specified DC.
    Call SetBkMode(hdc, vbTransparent)
    
    ' color of text drop shadow
    Call SetTextColor(hdc, RGB(0, 0, 0))
    
    ' draw text shadow with offset
    Call TextOut(hdc, X + 2, Y + 2, Text, Len(Text))
    Call TextOut(hdc, X + 1, Y + 1, Text, Len(Text))
    
    ' draw text with color
    Call SetTextColor(hdc, Color)
    Call TextOut(hdc, X, Y, Text, Len(Text))
End Sub

Public Sub DrawPlayerName(ByVal Index As Long)
Dim TextX As Long
Dim TextY As Long
Dim Color As Long
    
    ' Check access level to determine color
    If GetPlayerPK(Index) = NO Then
        Select Case GetPlayerAccess(Index)
            Case 0
                Color = QBColor(Brown)
            Case 1
                Color = QBColor(DarkGrey)
            Case 2
                Color = QBColor(Cyan)
            Case 3
                Color = QBColor(Blue)
            Case 4
                Color = QBColor(Pink)
        End Select
    Else
        Color = QBColor(BrightRed)
    End If

    ' Determine location for text
    TextX = GetPlayerX(Index) * PIC_X + Player(Index).XOffset + (PIC_X \ 2) - ((Len(GetPlayerName(Index)) / 2) * 8)
    TextY = GetPlayerY(Index) * PIC_Y + Player(Index).YOffset - (PIC_Y \ 2) - 4
    
    ' Draw name
    Call DrawText(TexthDC, TextX, TextY, GetPlayerName(Index), Color)
End Sub

Public Function DrawMapAttributes()
    Dim X As Long
    Dim Y As Long
    
        For X = 0 To MAX_MAPX
            For Y = 0 To MAX_MAPY
                With Map.Tile(X, Y)
                    Select Case .Type
                    
                        Case TILE_TYPE_BLOCKED
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "B", QBColor(BrightRed)
                        
                        Case TILE_TYPE_WARP
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "W", QBColor(BrightBlue)
                    
                        Case TILE_TYPE_ITEM
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "I", QBColor(White)
                    
                        Case TILE_TYPE_NPCAVOID
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "N", QBColor(White)
                    
                        Case TILE_TYPE_KEY
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "K", QBColor(White)
                    
                        Case TILE_TYPE_KEYOPEN
                            DrawText TexthDC, ((X * PIC_X) - 4) + (PIC_X * 0.5), ((Y * PIC_Y) - 7) + (PIC_Y * 0.5), "O", QBColor(White)
                    
                    End Select
                End With
            Next
        Next
    
End Function


