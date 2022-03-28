## Question2: Fairness in card games


### Modify the naive protocol so that brute force doesn’t work.
Let's map all cards from 0 to 51, the player can commit the hash of concatenation of (the card, the salt). The salt is a random number that the player chose. 

###  the player needs to pick another card from the same suite

Let 
* spades be 0 - 12 
* hearts be 13 - 25
* clubs be 26 - 38
* diamonds be 39 - 52


