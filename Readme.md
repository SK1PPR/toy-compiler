# C-Toy

## Introduction
C-toy is a toy compiler for the C programming language
Each stage of the compiler is provided as seperate releases
The compiler uses `flex` and `bison` 

Stages:
- [x] Lexical Analysis
- [ ] Syntax Analysis
- [ ] Semantic Analysis
- [ ] Pre Processor
- [ ] Intermediate Code Generation
- [ ] Code Optimisation
- [ ] Machine Code Generation

## Setup

The project uses `Cmake` as the build-system generator and `Ninja` (optional) as the build-tool.
The project also uses `google-test` for testing.
- Make sure `Cmake` is present in your system
- Make sure `gtest` is present in your system
- Commands:
```
mkdir build
cd build
cmake ..` or if you have *Ninja* use `cmake -G Ninja ..
```

## Build

After complete setup run the following command (assuming you are in root directory):
```
cmake --build build
```

## Run

After completing Setup and Build steps run the following command:
```./build/ctoy/ctoy_compiler```

## Testing

After completing Setup and Buld steps run the following commands

```
cd build
ctest
```

## References

- "Canonical Project Structure" for C++ referenced from [here](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2018/p1204r0.html)
- Pseudo-code for compiler and basic overview referenced from [dragon book](https://suif.stanford.edu/dragonbook/)
- Referenced an older compiler for C created for my college course you can find [here](https://github.com/sanatan01/CSN-352-Project)
- The C grammar used can be found [here](https://cs.wmich.edu/~gupta/teaching/cs4850/sumII06/The%20syntax%20of%20C%20in%20Backus-Naur%20form.htm)
- Test-suite can be found [here](https://github.com/c-testsuite/c-testsuite)