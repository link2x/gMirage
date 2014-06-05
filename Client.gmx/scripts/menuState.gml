// From modGeneral
room_goto(rmSendGetData);

    switch (State) {
        case MENU_STATE_NEWACCOUNT:
            if ConnectToServer {
                setStatus("Connected, sending new account information...");
                sendNewAccount(frmNewAccount.txtName.Text, frmNewAccount.txtPassword.Text); // UI needs to be built for this.
            }
        break;
            
        case MENU_STATE_DELACCOUNT:
            if ConnectToServer {
                setStatus("Connected, sending account deletion request ...");
                sendDelAccount(frmDeleteAccount.txtName.Text, frmDeleteAccount.txtPassword.Text);
                return 0;
            }
        break;
       
        case MENU_STATE_LOGIN:
            if ConnectToServer {
                setStatus("Connected, sending login information...");
                sendLogin(frmLogin.txtName.Text, frmLogin.txtPassword.Text);
                return 0;
            }
        break;
        
        case MENU_STATE_NEWCHAR:
            setStatus("Connected, getting available classes...");
            sendGetClasses
        break;
            
        case MENU_STATE_ADDCHAR:
            if ConnectToServer {
                setStatus("Connected, sending character addition data...");
                if frmNewChar.optMale.Value {        
                    sendAddChar(frmNewChar.txtName, SEX_MALE, frmNewChar.cmbClass.ListIndex + 1, frmChars.lstChars.ListIndex + 1);
                } else {
                    sendAddChar(frmNewChar.txtName, SEX_FEMALE, frmNewChar.cmbClass.ListIndex + 1, frmChars.lstChars.ListIndex + 1);
                }
            }
        break;
        
        case MENU_STATE_DELCHAR:
            if ConnectToServer {
                setStatus("Connected, sending character deletion request...");
                sendDelChar(frmChars.lstChars.ListIndex + 1);
            }
        break;
            
        case MENU_STATE_USECHAR:
            if ConnectToServer {
                setStatus("Connected, sending char data...");
                sendUseChar(frmChars.lstChars.ListIndex + 1);
            }
        break;
    }

    if (room=rmSendGetData) {
        if !IsConnected {
            room_goto(rmMainMenu);
            msgBox("Sorry, the server seems to be down.  Please try to reconnect in a few minutes or visit " & GAME_WEBSITE, vbOKOnly, GAME_NAME)
        }
    }
