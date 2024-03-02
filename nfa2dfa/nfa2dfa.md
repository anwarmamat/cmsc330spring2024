## Subset Construction (NFA to DFA Conversion) Examples

### Example 1
![NFA 1](images/nfa1.svg)

|States   | a  | b  | c  |
|:---:|:---:|:---:|:---:|
|{0,2}| 1   | phi  | 2  | 
|1   | Ø  | {0,2}  | Ø  |  
|2   | Ø  | Ø  | c  |  

![DFA 1](images/dfa1.svg)


### Example 2
![NFA 2](images/nfa2.svg)

|States   | a  | b  |
|:---:|:---:|:---:|
|{1,3}| Ø   | {2,4}  | 
|{2,4}| {2,3}  |Ø  |  
|{2,3} | {2,3}  | 4  |    
|4 | Ø  | Ø  |    

![DFA 2](images/dfa2.svg)
### Example 3
![NFA 3](images/nfa3.svg)

|States   | a  | 
|:---:|:---:|
|{1,3,4}|{1,2,3,4}  | 
|{1,2,3,4}| {1,2,3,4}  | 

![DFA 3](images/dfa3.svg)

### Example 4
![NFA 4](images/nfa4.svg)

|States | 0| 1 |
|:---:|:---:|:---:|
|{A,C} |{B,C} |{C,D}|
|{B,C} |C |{C,D}|
|C |C |{C,D}|
|{C,D} |C |{C,D}|

![DFA 4](images/dfa4.svg)

### Example 5
![NFA 5](images/nfa5.svg)

|States | a| b |
|:---:|:---:|:---:|
|0 |{0,1} |Ø|
|{0,1} |{0,1} |{2,3}|
|{2,3} |{0,1} |{2,3,4}|
|{2,3,4} |{0,1} |{2,3,4}|

![DFA 5](images/dfa5.svg)