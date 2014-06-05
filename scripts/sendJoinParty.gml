// From modClientTCP

// Suggesting a modification here. It appears there's no way to deny requests at all or even be
// specific what request you're accepting. Unless there's some sort of server-side code, it would
// seem you just accept whatever request came last.

// So yeah, I suggest modifying this to allow you to be specific about which request you're accepting,
// and add another packet type for denial.

writebyte(CJoinParty,0);      // Packet Type
sendData();
