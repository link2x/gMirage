// From modGeneral
//
// Break out of GameLoop.
global.InGame = False;
    
destroyTCP();

destroyDirectMusic();
destroyDirectSound();
destroyDirectDraw();
    
// Destory DirectX7 master object
/*
if Not DX7 Is Nothing Then
    Set DX7 = Nothing
End If
*/
// I'm not wasting my time on that. Once I'm done wrapping DirectX to Game Maker, it'll be removed.

game_end();
