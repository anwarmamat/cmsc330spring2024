
 fn app_int<T>(f:T,x:i32) -> i32
    where T:Fn(i32) -> i32
 {
   f(x)
 }

fn id(x:i32)->i32{
  x
}

fn app<T,U,W>(f:T,x:U) -> W
    where T:Fn(U) -> W
{
  f(x)
}

fn main() {

    let cls = |x| x - 1 ;;
    println!("{}",app_int(cls,10));
    println!("{}",app_int(id,100));
    
    println!("{}",app(|x| x-1,1));//i32

    let s = String::from("hi ");
    {
        let f = |x:String| {let m = x; "there"};
        println!("{}",app(f,s));//String
    }
    //println!("{}",s);   //error. s moved
   
}
