

#[derive(Debug)]
enum IpAddr{
  V4(String),
  V6(String),
  V8
}

impl IpAddr {
  fn call(&self) ->String {
  // method body would be defined here
  let t = String::from("hello");
  t
  }
}



fn main(){
  let home = IpAddr::V4(String::from("127.0.0.1"));
  let loopback = IpAddr::V6(String::from("::1"));

  println!("{:?}", home);
  println!("{:?}", loopback.call());

}
