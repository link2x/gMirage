Option Explicit

' ******************************************
' **            Mirage Source 4           **
' ******************************************

' halts thread of execution
Public Declare Sub Sleep Lib "kernel32.dll" (ByVal dwMilliseconds As Long)

 ' get system uptime in milliseconds (32-bit)
Public Declare Function GetTickCount Lib "kernel32.dll" () As Long

'For Clear functions
Public Declare Sub ZeroMemory Lib "kernel32.dll" Alias "RtlZeroMemory" (Destination As Any, ByVal Length As Long)

Public Sub Main()
   
    frmSendGetData.Visible = True
    Call SetStatus("Loading...")
    
    GettingMap = True
    vbQuote = ChrW$(34) ' "
    
    Load frmMirage
    
    ' Update the form with the game's name
    frmMirage.Caption = GAME_NAME
    frmMirage.lblName.Caption = GAME_NAME

    ' randomize rnd's seed
    Randomize
    
    Call InitFont

    Call SetStatus("Initializing TCP settings...")
    Call TcpInit

    Call SetStatus("Initializing DirectX...")
    ' DX7 Master Object is already created, early binding
    Call CheckTiles
    Call CheckSprites
    Call CheckSpells
    Call CheckItems
        
    ' DirectDraw Surface memory management setting
    DDSD_Temp.lFlags = DDSD_CAPS
    DDSD_Temp.ddsCaps.lCaps = DDSCAPS_OFFSCREENPLAIN Or DDSCAPS_VIDEOMEMORY

    Load frmMainMenu ' this line also initalizes directX
    
    frmMainMenu.Visible = True
    frmSendGetData.Visible = False
End Sub

Public Sub MenuState(ByVal State As Long)
    frmSendGetData.Visible = True

    Select Case State
        Case MENU_STATE_NEWACCOUNT
            frmNewAccount.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending new account information...")
                Call SendNewAccount(frmNewAccount.txtName.Text, frmNewAccount.txtPassword.Text)
            End If
            
        Case MENU_STATE_DELACCOUNT
            frmDeleteAccount.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending account deletion request ...")
                Call SendDelAccount(frmDeleteAccount.txtName.Text, frmDeleteAccount.txtPassword.Text)
                Exit Sub
            End If
       
        Case MENU_STATE_LOGIN
            frmLogin.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending login information...")
                Call SendLogin(frmLogin.txtName.Text, frmLogin.txtPassword.Text)
                Exit Sub
            End If
        
        Case MENU_STATE_NEWCHAR
            frmChars.Visible = False
            Call SetStatus("Connected, getting available classes...")
            Call SendGetClasses
            
        Case MENU_STATE_ADDCHAR
            frmNewChar.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending character addition data...")
                If frmNewChar.optMale.Value Then
                                                        
                    Call SendAddChar(frmNewChar.txtName, SEX_MALE, frmNewChar.cmbClass.ListIndex + 1, frmChars.lstChars.ListIndex + 1)
                Else
                    Call SendAddChar(frmNewChar.txtName, SEX_FEMALE, frmNewChar.cmbClass.ListIndex + 1, frmChars.lstChars.ListIndex + 1)
                End If
            End If
        
        Case MENU_STATE_DELCHAR
            frmChars.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending character deletion request...")
                Call SendDelChar(frmChars.lstChars.ListIndex + 1)
            End If
            
        Case MENU_STATE_USECHAR
            frmChars.Visible = False
            If ConnectToServer Then
                Call SetStatus("Connected, sending char data...")
                Call SendUseChar(frmChars.lstChars.ListIndex + 1)
            End If
    End Select

    If frmSendGetData.Visible Then
        If Not IsConnected Then
            frmMainMenu.Visible = True
            frmSendGetData.Visible = False
            Call MsgBox("Sorry, the server seems to be down.  Please try to reconnect in a few minutes or visit " & GAME_WEBSITE, vbOKOnly, GAME_NAME)
        End If
    End If
    
End Sub

Public Sub GameInit()
    Unload frmMainMenu
    Unload frmLogin
    Unload frmNewAccount
    Unload frmDeleteAccount

    frmSendGetData.Visible = False
    
    frmMirage.Show
    
    ' Set the focus
    Call SetFocusOnChat

End Sub

Public Sub DestroyGame()
    ' break out of GameLoop
    InGame = False
    
    Call DestroyTCP
    
    'destroy objects in reverse order
    Call DestroyDirectMusic
    Call DestroyDirectSound
    Call DestroyDirectDraw
    
    ' destory DirectX7 master object
    If Not DX7 Is Nothing Then
        Set DX7 = Nothing
    End If
    
    Call UnloadAllForms
    End
End Sub

Public Sub UnloadAllForms()
    Dim frm As Form

    For Each frm In VB.Forms
        Unload frm
    Next
End Sub

Public Sub SetStatus(ByVal Caption As String)
    frmSendGetData.lblStatus.Caption = Caption
    DoEvents
End Sub

Public Sub AddText(ByVal Msg As String, ByVal Color As Integer)
Dim s As String
  
    s = vbNewLine & Msg
    
    With frmMirage.txtChat
        .SelStart = Len(.Text)
        .SelColor = QBColor(Color)
        .SelText = s
        .SelStart = Len(.Text) - 1
    
    
        ' Prevent players from name spoofing
        .SelHangingIndent = 15
    End With
    
End Sub

' Used for adding text to packet debugger
Public Sub TextAdd(ByVal Txt As TextBox, Msg As String, NewLine As Boolean)
    If NewLine Then
        Txt.Text = Txt.Text + Msg + vbCrLf
    Else
        Txt.Text = Txt.Text + Msg
    End If
    
    Txt.SelStart = Len(Txt.Text) - 1
End Sub

Public Sub SetFocusOnChat()
On Error Resume Next 'prevent RTE5, no way to handle error
    frmMirage.txtMyChat.SetFocus
End Sub

Public Function Rand(ByVal Low As Long, ByVal High As Long) As Long
  Rand = Int((High - Low + 1) * Rnd) + Low
End Function

Public Sub MovePicture(PB As PictureBox, Button As Integer, Shift As Integer, X As Single, Y As Single)
    Dim GlobalX As Integer
    Dim GlobalY As Integer

    GlobalX = PB.Left
    GlobalY = PB.Top

    If Button = 1 Then
        PB.Left = GlobalX + X - SOffsetX
        PB.Top = GlobalY + Y - SOffsetY
    End If
End Sub

Public Sub ResetUI()
    With frmMirage
        .picInvList.Left = 0
        .picInvList.Top = 0
        
        .picSpellsList.Left = 0
        .picSpellsList.Top = 0
    End With
End Sub

Public Function isLoginLegal(ByVal Username As String, ByVal Password As String) As Boolean
    If LenB(Trim$(Username)) >= 3 Then
        If LenB(Trim$(Password)) >= 3 Then
            isLoginLegal = True
        End If
    End If
End Function

Public Function isStringLegal(ByVal sInput As String) As Boolean
Dim i As Long

    ' Prevent high ascii chars
    For i = 1 To Len(sInput)
        If Asc(Mid$(sInput, i, 1)) < vbKeySpace Or Asc(Mid$(sInput, i, 1)) > vbKeyF15 Then
            Call MsgBox("You cannot use high ASCII characters in your name, please re-enter.", vbOKOnly, GAME_NAME)

                        Exit Function
        End If
    Next
    
    isStringLegal = True
        
End Function
