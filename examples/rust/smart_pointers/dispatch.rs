// Static dispatch
fn call_with_one<F>(s:F) -> i32
   where F: Fn(i32) -> i32 {
 s(1)
}

// Dynamic dispatch
fn call_with_one2(some_closure: &dyn Fn(i32) -> i32) -> i32 {
    some_closure(1)
}

fn main() {
    let y = 10;
    let f = |x| x + 2 + y ;
    let answer = call_with_one(f);
    println!("{}" ,answer);
    let answer2 = call_with_one2(&f);
    println!("{}" ,answer2);

}