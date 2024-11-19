/*
Closures can capture variables:
    by reference: &T
    by mutable reference: &mut T
    by value: T
*/
fn main() {
    let x = 4;
    let equal_to_x = |z| z == x;
    let y = 4;
    assert!(equal_to_x(y));
    assert!(equal_to_x(y));
    println!("{}",x);

    let s = String::from("hi");

    let add_x = |z| s+z; //captures x; is FnOnce

    //println!("x = {}",x); //fails

    let r = add_x(" there");//consumes closure

    //println!("{}",s);

    println!("{}",r);

    //let t = add_x(" joe");//fails, add_x consumed

    // Closure can borrow the outer variable

    let s2 = String::from(" there");
    let borrow_s = |z:String| z + &s2; // borrow s2

    println!("s2 = {}",s2); 

    let r2 = borrow_s("hi".to_string());
    
    //let s3 = s2; //can't move s2 because it is borrowed in the closure borrow_s

    println!("{}",s2);

    println!("{}",r2);

    let t = borrow_s("hey".to_string());
    println!("{}",t);

    let haystack = vec![1, 2, 3];

    let contains = move |needle| {foo(10);haystack.contains(needle)};

    println!("{}", contains(&1));
    println!("{}", contains(&4));
    //println!("{}", haystack.len());
    
}
