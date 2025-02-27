# 99 Problemsin Rust
1. Find the last item of a vector. 
```rust
 let a = vec![1,3,5];
 println!("{}", a.last().unwrap());  // 5
 println!("{:?}", a.last()); //Some(5)
```
2. Find the last two items in a vector/ 
```rust
let a = vec![1i32,3,5];
let len = a.len();
println!("{:?}", &a[len-2..len]); //[3, 5]
```
3. Find the K'th element of a list.
```rust
let a = vec![1,3,5];
let k = 1;
println!("{:?}", a[k]); //3
```
4. Find the number of elements of a vector
```rust
let a = vec![1,3,5];
println!("{}", a.len()); //3
```
5. Reverse a vector
```rust
let mut a = vec![1i32,3,5];
a.reverse();
println!("{:?}", a); //[5, 3, 1]
```
6. Find out whether a vector is a palindrome.
```rust
fn is_palindrome_rec<T: Eq>(a: &[T]) -> bool {
  match a {
    [] => true,
    [_] => true,
    [ref x, xs @ .., ref y] => x == y && is_palindrome_rec(xs),
  }
}

fn is_palindrome_iter<T: Eq>(a: &[T]) -> bool {
  a.iter().zip(a.iter().rev()).all(|(x,y)| x == y)
}

fn main() {
  let a = &[1i32,3,1];
  println!("{}", is_palindrome_rec(a));
  println!("{}", is_palindrome_iter(a));
}
```
7. Flatten a nested list structure. Transform a list, possibly holding lists as elements into a `flat' list by replacing each list with its elements (recursively).
```rust
use Node::{One, Many};

enum Node<T> {
  One(T),
  Many(Vec<Node<T>>),
}

fn flatten<T>(a: Node<T>) -> Vec<T> {
  match a {
    One(x) => vec![x],
    Many(xs) => xs.into_iter().flat_map(|x| flatten(x).into_iter()).collect(),
  }
}

fn main() {
  let a = Many(vec![Many(vec![One(1i32),One(2)]),One(3),One(4)]);
  println!("{:?}", flatten(a));
}
```
8. Eliminate consecutive duplicates of list elements. If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.
```rust
fn compress<T: Eq>(a: Vec<T>) -> Vec<T> {
  let mut r = vec![];
  for x in a.into_iter() {
    if r.is_empty() || r.last().unwrap() != &x {
      r.push(x)
    }
  }
  r
}

fn compress_lib<T: Eq>(mut a: Vec<T>) -> Vec<T> {
  a.dedup();
  a
}

fn main() {
  let a = vec![1i32, 1, 2, 3, 3, 4];
  println!("{:?}", compress(a.clone())); //[1, 2, 3, 4]
  println!("{:?}", compress_lib(a));  //[1, 2, 3, 4]
}
```
9. Pack consecutive duplicates of list elements into sublists. If a list contains repeated elements they should be placed in separate sublists.
```rust
fn pack<T: Eq>(a: Vec<T>) -> Vec<Vec<T>> {
  let mut r: Vec<Vec<T>> = vec![];
  for x in a.into_iter() {
    if r.is_empty() || r.last().unwrap().last().unwrap() != &x {
      r.push(vec![x])
    } else {
      r.last_mut().unwrap().push(x)
    }
  }
  r
}

fn main() {
  let a = vec![1i32, 1, 2, 3, 3, 4];  
  println!("{:?}", pack(a));  //[[1, 1], [2], [3, 3], [4]]
}
```
10. Run-length encoding of an array. Consecutive duplicates of elements are encoded as tuples (N, E) where N is the number of duplicates of the element E.
```rust
fn rle<T: Eq>(a: Vec<T>) -> Vec<(usize, T)> {
  let mut r: Vec<(usize, T)> = vec![];
  for x in a.into_iter() {
    let mut flag = true;
    if let Some(&mut (ref mut l, ref y)) = r.last_mut() {
      if x == *y {
        flag = false;
        *l += 1;
      }
    }
    if flag {
      r.push((1, x))
    }
  }
  r
}

fn main() {
  let a = vec![1, 1, 1, 2, 3, 3, 4];
  println!("{:?}", rle(a)); //[(3, 1), (1, 2), (2, 3), (1, 4)]
}
```
11. Modified run-length encoding.
    Modify the result of problem P10 in such a way that if an element has no duplicates it is simply copied into the result list. Only elements with duplicates are transferred as (N E) lists.
```rust
use Elem::{Unique, Several};

#[derive(Debug)]
enum Elem<T> { Unique(T), Several(usize, T), }

fn encode_bis<T: Clone + Eq>(a: Vec<T>) -> Vec<Elem<T>> {
  let mut r: Vec<Elem<T>> = vec![];
  for x in a.into_iter() {
    let w =
      match r.last() {
        Some(&Unique(ref y)) if x == *y => Some(Several(2, y.clone())),
        Some(&Several(l, ref y)) if x == *y => Some(Several(l + 1, y.clone())),
        _ => None,
      };
    match w {
      None => r.push(Unique(x)),
      Some(w) => *r.last_mut().unwrap() = w,
    }
  }
  r
}

fn main() {
  let a = vec![1, 1, 1, 2, 3, 3, 4];
  println!("{:?}" , encode_bis(a)); //[Several(3, 1), Unique(2), Several(2, 3), Unique(4)]
}
```
12. Decode a run-length encoded list. Given a run-length code list generated as specified in problem P11. Construct its uncompressed version.
```rust
#[derive(Debug)]
enum Elem<T> {
  Unique(T),
  Several(usize, T)
}
use Elem::{Unique, Several};

fn decode<T: Clone>(a: Vec<Elem<T>>) -> Vec<T> {
  a.into_iter().flat_map(|e|
    match e {
      Unique(x) => vec![x],
      Several(n, x) => std::iter::repeat(x).take(n).collect()
    }.into_iter()
  ).collect()
}

fn main() {
  let a: Vec<Elem<isize>> = vec![Several(3, 1), Unique(2), Several(2, 3), Unique(4)];
  println!("{:?}", decode(a)); //[1, 1, 1, 2, 3, 3, 4]
}
```
13. Run-length encoding of a vector. Implement the so-called run-length encoding data compression method directly. I.e. don't explicitly create the sublists containing the duplicates, as in problem P09, but only count them. As in problem P11, simplify the result list by replacing the singleton lists (1 X) by X.
```rust
use Elem::{Unique, Several};

#[derive(Show)]
enum Elem<T> { Unique(T), Several(usize, T), }

fn encode_bis<T: Clone + Eq>(a: Vec<T>) -> Vec<Elem<T>> {
  let mut r: Vec<Elem<T>> = vec![];
  for x in a.into_iter() {
    let w =
      match r.last() {
        Some(&Unique(ref y)) if x == *y => Some(Several(2, y.clone())),
        Some(&Several(l, ref y)) if x == *y => Some(Several(l + 1, y.clone())),
        _ => None,
      };
    match w {
      None => r.push(Unique(x)),
      Some(w) => *r.last_mut().unwrap() = w,
    }
  }
  r
}

fn main() {
  let a = vec![1, 1, 1, 2, 3, 3, 4];
  println!("{:?}" , encode_bis(a)); //[Several(3, 1), Unique(2), Several(2, 3), Unique(4)]
}
```
14. Duplicate the elements of a list.
```rust
fn dupli<T: Clone>(a: Vec<T>) -> Vec<T> {
  a.into_iter().flat_map(|x| vec![x.clone(),x].into_iter()).collect()
}

fn main() {
  let a = vec![1, 2, 3, 4];
  println!("{:?}" , dupli(a)); //[1, 1, 2, 2, 3, 3, 4, 4]
}
```
15. Replicate the elements of a list a given number of times.
```rust
fn repli<T: Clone>(n: usize, a: Vec<T>) -> Vec<T> {
  a.into_iter().flat_map(|x| std::iter::repeat(x).take(n)).collect()
}

fn main() {
  let a = let a = vec![1, 2, 4];
  println!("{:?}" , repli(3, a));  //[1, 1, 1, 2, 2, 2, 4, 4, 4]
}
```
16. Drop every N'th element from a list.
```rust
fn drop<T>(a: Vec<T>, n: usize) -> Vec<T> {
  a.into_iter().enumerate().filter_map(|(i,x)|
    if i%n < n-1 { Some(x) } else { None }
    ).collect()
}

fn main() {
  let a = vec!["a", "b", "c", "d","e","f","g"];
  println!("{:?}" , drop(a, 3)); //["a", "b", "d", "e", "g"]
}
```
17. Split a list into two parts; the length of the first part is given.
```rust
fn split<'a, T>(a: &'a [T], n: usize) -> (&'a [T], &'a [T]) {
  a.split_at(std::cmp::min(n, a.len()))
}

fn main() {
  let a: &[i32; 7] = &[1, 2, 3, 4, 5, 6, 7];
  println!("{:?}" , split(a, 13)); //([1, 2, 3], [4, 5, 6, 7])
}
```
18. Extract a slice from a list. Given two indices, I and K, the slice is the list containing the elements between the I'th and K'th element of the original list (both limits included). 
```rust
use std::cmp::min;

fn slice<T>(a: &[T], i: usize, j: usize) -> &[T] {
    &a[min(i, a.len())..min(j + 1, a.len())]
}

fn main() {
    let a = &[1, 2, 3, 4, 5, 6, 7];
    println!("{:?}", slice(a, 2, 5)); //[3, 4, 5, 6]
}

```
19. Rotate a list N places to the left.
```rust
fn rotate<T: Clone + std::fmt::Debug>(a: Vec<T>, n: usize) -> Vec<T> {
    let t = n % a.len();
    let mut r = vec![];

    r.append(&mut a[t..].to_vec());
    r.append(&mut a[0..t].to_vec());
    println!("{:?}", a);
    r
}

fn main() {
    let a = vec![1, 2, 3, 4];
    println!("{:?}", rotate(a, 3)); //[4, 1, 2, 3]
}

```
20. Remove the K'th element from a list.
```rust
fn remove_at<T>(a: &mut Vec<T>, i: usize) -> &mut Vec<T> {
    a.remove(i);
    a
}

fn main() {
    let mut a = vec!["a", "b", "c", "d"]; 
    println!("{:?}", remove_at(&mut a, 2)); //["a", "b", "d"]
}
```
21. Insert an element at a given position into a list. 
```rust
use std::cmp::min;

fn insert_at<T>(x: T, a: Vec<T>, i: usize) -> Vec<T> {
    let mut a = a;
    let l = a.len();
    a.insert(min(i, l), x);
    a
}

fn main() {
    let a = vec![1, 2, 3, 4];
    println!("{:?}", insert_at(0, a, 1));
}
```
22. Create a list containing all integers within a given range.
    If first argument is smaller than second, produce a list in decreasing order.
```rust
fn range1(lo: i32, hi: i32) -> Vec<i32> {
    let mut v = Vec::new();
    if lo < hi {
        for i in lo..hi + 1 {
            v.push(i);
        }
    } else {
        for i in hi..lo + 1 {
            v.push(i);
        }
        v.reverse();
    }
    v
}

use num_iter; //add 'num-iter = "0.1.45"' to your Cargo.toml:
fn range(left: i32, right: i32) -> Vec<i32> {
    if left < right {
        num_iter::range(left, right + 1).collect()
    } else {
        num_iter::range(right, left + 1).rev().collect()
    }
}
fn main() {
    let v1 = range1(2, 10);
    let v2 = range1(12, 5);
    println!("{:?}", v1);
    println!("{:?}", v2);
}
```

23. Extract a given number of randomly selected elements from a list.
    The selected items shall be returned in a list.

24. Lotto: Draw N different random numbers from the set 1..M.
    The selected numbers shall be returned in a list.


25. Generate a random permutation of the elements of a list.

26. Generate the combinations of K distinct objects chosen from the N elements of a list. In how many ways can a committee of 3 be chosen from a group of 12 people? We all know that there are C(12,3) = 220 possibilities (C(N,K) denotes the well-known binomial coefficients). For pure mathematicians, this result may be great. But we want to really generate all the possibilities in a list.

27. Group the elements of a set into disjoint subsets.
    

28. Sorting a list of lists according to length of sublists

31. Determine whether a given integer number is prime.

32. Determine the greatest common divisor of two positive integer numbers.
    Use Euclid's algorithm.

33. Determine whether two positive integer numbers are coprime.
    Two numbers are coprime if their greatest common divisor equals 1.

34. Calculate Euler's totient function phi(m).
    Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.

P35. Determine the prime factors of a given positive integer.
    Construct a flat list containing the prime factors in ascending order.

36. Determine the prime factors of a given positive integer (2).
    Construct a list containing the prime factors and their multiplicity.
    Example:

37. Calculate Euler's totient function phi(m) (improved).
    See problem P34 for the definition of Euler's totient function. If the list of the prime factors of a number m is known in the form of problem P36 then the function phi(m) can be efficiently calculated as follows: Let ((p1 m1) (p2 m2) (p3 m3) ...) be the list of prime factors (and their multiplicities) of a given number m. Then phi(m) can be calculated with the following formula:

38. Compare the two methods of calculating Euler's totient function.
    Use the solutions of problems P34 and P37 to compare the algorithms. Take the number of basic operations, including CARs, CDRs, CONSes, and arithmetic operations, as a measure for efficiency. Try to calculate phi(10090) as an example.

39. A list of prime numbers.
    Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.

40. Goldbach's conjecture.
    Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. It has been numerically confirmed up to very large numbers (much larger than we can go with our Lisp system). Write a function to find the two prime numbers that sum up to a given even integer.
