// From modGeneral
//
// Prevent high ascii chars
//
//

input = argument0;
legalString = true;

for (i=-1,i<=string_length(argument0),i+=1) {
if (ord(string_copy(input,i,1))<ord(" ")) or (ord(string_copy(input,i,1))>126) {
legalString = false;
msgBox("You cannot use high ASCII characters in your name, please re-enter.", vbOKOnly, GAME_NAME);
}
}
return legalString;
