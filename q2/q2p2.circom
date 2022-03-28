
template CheckSameSuite(){
    signal private input card1;
    signal private input salt1;
    signal private input card2;
    signal private input salt2;

    signal shaOf1;
    signal shaOf2;

    signal input card1Commit;
    signal input card2Commit;

    // Q: is private needed here??
    signal private card1Suite;
    signal private card2Suite;

    card1Suite <== card1/13;
    card2Suite <== card2/13;

    card1Suite === card2Suite;

    // SHA256 calculations

    //
    shaOf1 === card1Commit;
    shaOf2 === card2Commit;
}