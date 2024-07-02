module main
#(
    parameter steps = 256;
    parameter rng_seed = 0;
    parameter temperature = 1;
    parameter topp = 0.9;
)
(
    input argc, 
    input <pointer>argv[]
);