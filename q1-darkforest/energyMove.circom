pragma circom 2.0.0;
/*

In DarkForest the move circuit allows a player to hop from one planet to another.

Consider a hypothetical extension of DarkForest with an additional ‘energy’ parameter. 
If the energy of a player is 10, then the player can only hop to a planet at most 10 units away. 
The energy will be regenerated when a new planet is reached.

Consider a hypothetical move called the ‘triangle jump’, 
a player hops from planet A to B then to C and returns to A all in one move, 
such that A, B, and C lie on a triangle.

Write a Circom circuit that verifies this move. 
The coordinates of A, B, and C are private inputs. 
You may need to use basic geometry to ascertain that the move lies on a triangle. 
Also, verify that the move distances (A → B and B → C) are within the energy bounds. 

*/

/*
    Original proof

    Prove: I know (x1,y1,x2,y2,p2,r2,distMax) such that:
    - x2^2 + y2^2 <= r^2
    - perlin(x2, y2) = p2
    - (x1-x2)^2 + (y1-y2)^2 <= distMax^2
    - MiMCSponge(x1,y1) = pub1
    - MiMCSponge(x2,y2) = pub2

    New proof

    Prove I know (ax, ay, bx, by, cx, cy, )

*/

include "./node_modules/circomlib/circuits/comparators.circom";

template CheckEnergy() {
    signal input x1;
    signal input y1;

    signal input x2;
    signal input y2;

    signal input energy;
    signal firstDistSquare;
    signal secondDistSquare;

    signal diffX;
    diffX <== x1 - x2;
    signal diffY;
    diffY <== y1 - y2;

    component ltDist = LessThan(32);
    firstDistSquare <== diffX * diffX;
    secondDistSquare <== diffY * diffY;
    ltDist.in[0] <== firstDistSquare + secondDistSquare;
    ltDist.in[1] <== energy * energy + 1;
    ltDist.out === 1;
}


template EnergyTriangleJump() {

    // Triangular jump, A => B => C => A
    signal input ax;
    signal input ay;

    signal input bx;
    signal input by;

    signal input cx;
    signal input cy;

    signal input p2;
    signal input r;
    signal input distMax;
    signal input energyMax;

    signal output pub1;
    signal output pub2;

    // ###########################################################
    // check if ABC forms a triangle.
    // Area > 0 then it is a triangle
    // Q: Can I have multiple calculations in a line?
    area <== ax * (by - cy) + bx * (cy - ay) + cx * (ay - by);
    // Q: can I assert non-equal?
    assert(area > 0);
    // ###########################################################

    component abEnergy = CheckEnergy();
    abEnergy.x1 <== ax;
    abEnergy.y1 <== ay;
    abEnergy.x2 <== bx;
    abEnergy.y2 <== by;
    abEnergy.energy <== energyMax;

    component bcEnergy = CheckEnergy();
    bcEnergy.x1 <== bx;
    bcEnergy.y1 <== by;
    bcEnergy.x2 <== cx;
    bcEnergy.y2 <== cy;
    bcEnergy.energy <== energyMax;

    // CA should also be verified, as it is part of the move (C=>A)
    component caEnergy = CheckEnergy();
    caEnergy.x1 <== cx;
    caEnergy.y1 <== cy;
    caEnergy.x2 <== ax;
    caEnergy.y2 <== ay;
    caEnergy.energy <== energyMax;

}

