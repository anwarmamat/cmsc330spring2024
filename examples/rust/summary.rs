
pub trait Summarizable {
  fn summary(&self) -> String;
}


impl Summarizable for (i32,i32) {
    fn summary(&self) -> String {
        let (x,y) = & self;
        format!("{}",x+y)
    }
}


fn main(){
    let t1 = (10,20);
    let t2 = t1.summary();

    println!("{}", t2);
    println!("{:?}", t1);
}
