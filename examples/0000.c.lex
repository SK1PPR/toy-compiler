| Lexeme                    | Location  | Position        | Token Type      |
--------------------------------------------------------------------------------
| int                       | [  1-4  ] | 1               | KEYWORD         |
| main                      | [  5-9  ] | 1               | IDENTIFIER      |
| (                         | [  9-10 ] | 1               | PUNCTUATOR      |
| )                         | [ 10-11 ] | 1               | PUNCTUATOR      |
| {                         | [ 11-12 ] | 1               | PUNCTUATOR      |
| int                       | [  5-8  ] | 3               | KEYWORD         |
| x                         | [  9-10 ] | 3               | IDENTIFIER      |
| =                         | [ 11-12 ] | 3               | PUNCTUATOR      |
| 10                        | [ 13-15 ] | 3               | CONSTANT        |
| ;                         | [ 15-16 ] | 3               | PUNCTUATOR      |
| int                       | [  5-8  ] | 4               | KEYWORD         |
| y                         | [  9-10 ] | 4               | IDENTIFIER      |
| =                         | [ 11-12 ] | 4               | PUNCTUATOR      |
| 20                        | [ 13-15 ] | 4               | CONSTANT        |
| ;                         | [ 15-16 ] | 4               | PUNCTUATOR      |
| if                        | [  5-7  ] | 7               | KEYWORD         |
| (                         | [  8-9  ] | 7               | PUNCTUATOR      |
| x                         | [  9-10 ] | 7               | IDENTIFIER      |
| >                         | [ 11-12 ] | 7               | PUNCTUATOR      |
| y                         | [ 13-14 ] | 7               | IDENTIFIER      |
| )                         | [ 14-15 ] | 7               | PUNCTUATOR      |
| {                         | [ 16-17 ] | 7               | PUNCTUATOR      |
| printf                    | [  9-15 ] | 8               | IDENTIFIER      |
| (                         | [ 15-16 ] | 8               | PUNCTUATOR      |
| "x is greater than y\n"   | [ 16-39 ] | 8               | STRING_LITERAL  |
| )                         | [ 39-40 ] | 8               | PUNCTUATOR      |
| ;                         | [ 40-41 ] | 8               | PUNCTUATOR      |
| }                         | [  5-6  ] | 9               | PUNCTUATOR      |
| else                      | [  7-11 ] | 9               | KEYWORD         |
| {                         | [ 12-13 ] | 9               | PUNCTUATOR      |
| printf                    | [  9-15 ] | 10              | IDENTIFIER      |
| (                         | [ 15-16 ] | 10              | PUNCTUATOR      |
| "y is greater than x\n"   | [ 16-39 ] | 10              | STRING_LITERAL  |
| )                         | [ 39-40 ] | 10              | PUNCTUATOR      |
| ;                         | [ 40-41 ] | 10              | PUNCTUATOR      |
| }                         | [  5-6  ] | 11              | PUNCTUATOR      |
| return                    | [  5-11 ] | 13              | KEYWORD         |
| 0                         | [ 12-13 ] | 13              | CONSTANT        |
| ;                         | [ 13-14 ] | 13              | PUNCTUATOR      |
| }                         | [  1-2  ] | 14              | PUNCTUATOR      |
