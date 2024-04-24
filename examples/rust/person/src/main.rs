use person_example::person::{Account, Person};

fn main() {
    let p1 = Person {
        name: String::from("alice"),
        age: 29,
        account: Box::new(Account {
            routing: 1000,
            account: 2000,
        }),
    };

    let p2 = Person {
        name: String::from("bob"),
        age: 22,
        account: Box::new(Account {
            routing: 1001,
            account: 2001,
        }),
    };
    println!("{}", p1);
    println!("{:?}", p1);

    let t = p1 == p2; //PartialEq trait
    println!("{}", t);

    let t = p1 < p2; //PartialOrd trait
    println!("{}", t);

    let c1 = p1.clone(); //clone trait
    println!("{}", c1);
    println!("{}", p1);
}
