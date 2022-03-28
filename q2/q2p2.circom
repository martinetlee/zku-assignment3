pragma circom 2.0.0;
include "./node_modules/circomlib/circuits/bitify.circom";
include "./node_modules/circomlib/circuits/sha256/sha256.circom";

template CheckSameSuite(){
    signal input card1; // card1 < 52 < 64 = 2^6, reserve 8 bit
    signal input salt1; // reserve 253 bit
    signal input card2;
    signal input salt2;

    signal shaOf1;
    signal shaOf2;

    signal input card1Commit;
    signal input card2Commit;

    signal card1Suite;
    signal card2Suite;

    card1Suite <== card1 \ 13;
    card2Suite <== card2 \ 13;

    card1Suite === card2Suite;

    // SHA256 calculations
    component hasher1 = Sha256(256 + 8);
    component hasher2 = Sha256(256 + 8);

    component bitsSalt1 = Num2Bits_strict();
    component bitsSalt2 = Num2Bits_strict();
    bitsSalt1.in <== salt1;
    bitsSalt2.in <== salt2;

    component bitsCard1 = Num2Bits_strict();
    bitsCard1.in <== card1;
    component bitsCard2 = Num2Bits_strict();
    bitsCard2.in <== card2;


    var index = 0;
    for(var i = 0; i < 254; i++) {
        hasher1.in[index] <== bitsSalt1.out[253-i];
        hasher2.in[index] <== bitsSalt2.out[253-i];
        index++;
    }
    hasher1.in[index] <== 0;
    hasher2.in[index] <== 0;
    index++;
    hasher1.in[index] <== 0;
    hasher2.in[index] <== 0;
    index++;

    for(var i = 0; i < 8; i++) {
        hasher1.in[index] <== bitsCard1.out[8-i];
        hasher2.in[index] <== bitsCard2.out[8-i];
        index++;
    }

    component b2n1 = Bits2Num(256);
    component b2n2 = Bits2Num(256);
    for (var i = 0; i < 256; i++) {
        b2n1.in[i] <== hasher1.out[255 - i];
        b2n2.in[i] <== hasher2.out[255 - i];
    }

    shaOf1 <== b2n1.out;
    shaOf2 <== b2n2.out;

    //
    shaOf1 === card1Commit;
    shaOf2 === card2Commit;
}
component main {public [card1Commit, card2Commit]}= CheckSameSuite();