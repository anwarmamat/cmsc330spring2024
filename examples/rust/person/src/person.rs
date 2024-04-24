#[derive(Debug, PartialEq, Eq, Clone)]
pub struct Account {
    pub routing: u32,
    pub account: u32,
}
#[derive(Debug, Eq)]
pub struct Person {
    pub name: String,
    pub age: u8,
    pub account: Box<Account>,
}
use std::fmt::{Display, Formatter};

impl Display for Person {
    fn fmt(&self, f: &mut Formatter<'_>) -> Result<(), std::fmt::Error> {
        write!(
            f,
            "Person(Name: {}, Age: {}, Account:[{},{}])",
            self.name, self.age, self.account.routing, self.account.account
        )
    }
}
impl PartialEq for Person {
    fn eq(&self, other: &Self) -> bool {
        if self as *const _ == other as *const _ {
            true // if self and other are references to same data
        } else {
            self.name == other.name && self.account.account == other.account.account
        }
    }
}

impl PartialOrd for Person {
    fn partial_cmp(&self, other: &Person) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Person {
    fn cmp(&self, other: &Person) -> std::cmp::Ordering {
        self.name.cmp(&other.name)
    }
}

impl Clone for Person {
    fn clone(&self) -> Person {
        Person {
            name: self.name.clone(),
            age: self.age,
            account: self.account.clone(),
        }
    }
}
