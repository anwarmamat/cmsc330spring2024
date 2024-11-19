fn moveit(l:bool,x:i32) -> i32 {
    //let left = |x| x - 1;

    fn left(x:i32) -> i32 { x-1 };
    
    fn right(x:i32) -> i32 { x+1 };
    if l { left(x) }
    else { right(x) }
}

fn main(){
    let t = moveit(false, 100);
    println!("{}",t);

    let id = |x| x; 

    let x = id(1); //infers x:i32
    
    //let y = id("hi"); //fails: &str ≠ i32 

    

    

    
}
