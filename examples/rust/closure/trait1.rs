trait Printable {
    fn stringify(&self) -> String;
}

struct Point{
    x:i32,
    y:i32,
}
impl Printable for Point{
    fn stringify(&self) -> String{
        format!("x:{},y:{}",self.x,self.y) 
    }
}

impl Printable for i32 {
    fn stringify(&self) -> String { "This is ".to_string() + &self.to_string() }
}

fn main() {
    println!("{}",10.stringify());
    let p1 = Point{x:10,y:20};
    println!("{}",p1.stringify());
}