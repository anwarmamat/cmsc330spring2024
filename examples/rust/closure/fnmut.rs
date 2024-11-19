
fn apply<F>(mut f:F)->i32
  where F:FnMut(i32)->i32
  {
	f(10)
}


fn main(){
    let mut s = String::from("hello");

    {
        //closure
        let add5 = |x:i32| {
            s.push_str("world");
            println!("{}", s);
            x + 5
        };
        
        let t = apply(add5);
        println!("{}",t);
    }
    println!("{}",s);  //error. immutable borrow
}
