// From modClientTCP

// This check isn't really necessary as long as you don't let
// end-users set the IP. I'm not going to be putting this in.

// If you want to put a check in, though, do it like so:

// Make a list of the ord()s of all numbers and .
// Check that every character of argument0 is one of these.
// Check that there are only 3 .s
// Check that there are no more than 3 numbers in a row
// Check that there are no .s touching

// If everything checks out, return 1; otherwise, return 0; as
// soon as you find an issue.

// It's not hard, but again as long as you keep the IP in the
// code there isn't a reason to run a check.

// For now, this check will always go through.

ip = argument0;
return 1;
