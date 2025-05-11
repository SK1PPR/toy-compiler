# C-Toy

## Introduction
C-toy is a toy compiler for the C programming language
Each stage of the compiler is provided as seperate releases
The compiler uses `flex` and `bison` 

Stages:
- [ ] Lexical Analysis
- [ ] Syntax Analysis
- [ ] Semantic Analysis
- [ ] Pre Processor
- [ ] Intermediate Code Generation
- [ ] Code Optimisation
- [ ] Machine Code Generation

## Build

The project uses `Cmake` as the build-system generator and `Ninja` as the build-tool

## Run


## Testing


## References

- "Canonical Project Structure" for C++ referenced from [here](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1204r0.html)
- Pseudo-code for compiler and basic overview referenced from [dragon book](https://suif.stanford.edu/dragonbook/)
- Referenced an older compiler for C created for my college course you can find [here](https://github.com/sanatan01/CSN-352-Project)
- The C grammar used can be found [here](https://cs.wmich.edu/~gupta/teaching/cs4850/sumII06/The%20syntax%20of%20C%20in%20Backus-Naur%20form.htm)
- Test-suite can be found [here](https://github.com/c-testsuite/c-testsuite)