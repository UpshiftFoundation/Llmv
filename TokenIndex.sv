/*
Trying to convert a pointer from c to systemverilog

//
    typedef struct {
    char *str;
    int id;
    } TokenIndex;

//
*/ 

class TokenIndex;
    string str;
    int id; 

    // Constructor
    function new(string s = "", int i = 0);
        str = s;
        id = i;
    endfunction
endclass


/*

typedef struct {
    char** vocab;
    float* vocab_scores;
    TokenIndex *sorted_vocab;
    int vocab_size;
    unsigned int max_token_length;
    unsigned char byte_pieces[512]; // stores all single-byte strings
} Tokenizer;

*/
// Tokenizer -> is this the right way to go about this?
class Tokenizer
    string vocab[];
    real vocab_scores[]; // is float the correct type to use?
    int sorted_vocab[];
    int max_token_length;
    byte byte_pieces[512];
endclass 