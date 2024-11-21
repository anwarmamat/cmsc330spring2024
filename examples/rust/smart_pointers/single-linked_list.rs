use std::fmt::*;

/// A struct that represents a single node in a list
///
/// # State
/// * `element` - The element of type T that is stored in the node
/// * `next` - An optional value that points to the next element in the list
#[derive(PartialEq, Debug)]
pub struct Node<T: Debug> {
  pub element: T,
  pub next: Option<Box<Node<T>>>,
}

// TODO: Use Display instead of Debug.
// Question: How to use both display and debug together?
impl<T: Debug> Display for Node<T> {
  fn fmt(&self, f: &mut Formatter) -> Result {
    match &self.next {
      &Some(ref node) => write!(f, "{:?},{}", self.element, *node),
      &None => write!(f, "{:?}", self.element),
    }
  }
}

#[derive(Debug)]
pub struct List<T: Debug> {
  pub head: Option<Node<T>>,
}

impl<T: Debug> List<T> {
  pub fn new() -> Self {
    List { head: None }
  }

  pub fn new_from(vec: Vec<T>) -> Self {
    let mut list: List<T> = List::new();
    for element in vec {
      list.insert_at_end(element);
    }
    list
  }

  pub fn insert_at_beginning(&mut self, element: T) {
    let mut new_node = Node {
      next: None,
      element,
    };
    match self.head {
      None => self.head = Some(new_node),
      Some(_) => {
        let current_head = self.head.take().unwrap();
        new_node.next = Some(Box::new(current_head));
        self.head = Some(new_node);
      }
    }
  }

  pub fn delete_at_beginning(&mut self) {
    self
      .head
      .take()
      .map(|head| self.head = head.next.map(|node| *node));
  }

  pub fn length(&self) -> usize {
    let mut count = 0;
    let mut current_node = self.head.as_ref();
    while let Some(node) = current_node {
      count = count + 1;
      current_node = node.next.as_ref().map(|node| &**node)
    }
    count
  }

  pub fn add_all(&mut self, list_to_add: List<T>) {
    let length = self.length();
    if length > 0 {
      let last_node = self.get_nth_node_mut(length - 1);
      last_node.map(|node| {
        node.next = list_to_add.head.map(|node| Box::new(node))
      });
    } else {
      self.head = list_to_add.head
    }
  }

  pub fn add_all_at_index(&mut self, list_to_add: List<T>, index: usize) {
    if index > 0 {
      let nth_node = self.get_nth_node_mut(index).take();
      println!("{:?}", nth_node);
      nth_node.map(|node| {
        let current_next = node.next.take();
        node.next = list_to_add.head.map(|node| Box::new(node));
      });
    } else {
      self.head = list_to_add.head
    }
  }

  pub fn insert_at_end(&mut self, element: T) {
    let length = self.length();
    let new_node = Node {
      element: element,
      next: None,
    };
    if length > 0 {
      let last_node = self.get_nth_node_mut(length - 1);
      last_node.map(|node| node.next = Some(Box::new(new_node)));
    } else {
      self.head = Some(new_node)
    }
  }

  pub fn insert_at_index(&mut self, element: T, index: usize) {
    let new_node = Node {
      element: element,
      next: None,
    };
    if index > 0 {
      let last_node = self.get_nth_node_mut(index - 1);
      last_node.map(|node| node.next = Some(Box::new(new_node)));
    }
  }


  pub fn delete_at_end(&mut self) {
    let length = self.length();
    if length > 0 {
      let mut last_node = self.get_nth_node_mut(length - 1);
      last_node.take();
    }
  }

  fn get_nth_node_mut(&mut self, n: usize) -> Option<&mut Node<T>> {
    let mut nth_node = self.head.as_mut();
    for _ in 0..n {
      nth_node = match nth_node {
        None => return None,
        Some(node) => node.next.as_mut().map(|node| &mut **node),
      }
    }
    nth_node
  }

  pub fn iter(&self) -> ListIterator<T> {
    ListIterator {
      next: self.head.as_ref(),
    }
  }

  pub fn into_iter(self) -> ListOwnedIterator<T> {
    ListOwnedIterator { next: self.head }
  }

  pub fn iter_mut(&mut self) -> ListMutIterator<T> {
    ListMutIterator {
      next: self.head.as_mut(),
    }
  }

  //  fn iter_mut_node(&mut self) -> ListMutNodeIterator<T> {
  //   ListMutNodeIterator {
  //     next_node: None
  //     // next_node: self.head.as_mut().map(|node| &mut node)
  //   }
  // }
}

pub struct ListIterator<'a, T: Debug + 'a> {
  next: Option<&'a Node<T>>,
}

impl<'a, T: Debug> Iterator for ListIterator<'a, T> {
  type Item = &'a T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.map(|node| {
      self.next = node.next.as_ref().map(|node| &**node);
      &node.element
    })
  }
}

pub struct ListOwnedIterator<T: Debug> {
  next: Option<Node<T>>,
}

impl<T: Debug> Iterator for ListOwnedIterator<T> {
  type Item = T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.take().map(|mut node| {
      self.next = node.next.take().map(|node| *node);
      node.element
    })
  }
}

pub struct ListMutIterator<'a, T: Debug + 'a> {
  next: Option<&'a mut Node<T>>,
}

impl<'a, T: Debug> Iterator for ListMutIterator<'a, T> {
  type Item = &'a mut T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.take().map(|node| {
      self.next = node.next.as_mut().map(|next_node| &mut **next_node);
      &mut node.element
    })
  }
}

// struct ListMutNodeIterator<'a, T: Debug + 'a> {
//   next_node: Option< &'a mut Node<T>>,
// }

// impl<'a, T: Debug> Iterator for ListMutNodeIterator<'a, T> {
//   type Item =  &'a mut Node<T>;
//   fn next(&mut self) -> Option<Self::Item> {
//     self.next_node.take().map(|node| {
//       let next = node.next.take();
//       self.next_node = next.as_mut().map(|next_node| &mut **next_node);
//       node
//     });
//     None
//   }
// }

impl<T: Debug> Display for List<T> {
  fn fmt(&self, f: &mut Formatter) -> Result {
    let _ = write!(f, "[");
    match self.head {
      None => {}
      Some(ref node) => {
        let _ = write!(f, "{}", node);
      }
    }
    write!(f, "]")
  }
}
use std::fmt::*;

/// A struct that represents a single node in a list
///
/// # State
/// * `element` - The element of type T that is stored in the node
/// * `next` - An optional value that points to the next element in the list
#[derive(PartialEq, Debug)]
pub struct Node<T: Debug> {
  pub element: T,
  pub next: Option<Box<Node<T>>>,
}

// TODO: Use Display instead of Debug.
// Question: How to use both display and debug together?
impl<T: Debug> Display for Node<T> {
  fn fmt(&self, f: &mut Formatter) -> Result {
    match &self.next {
      &Some(ref node) => write!(f, "{:?},{}", self.element, *node),
      &None => write!(f, "{:?}", self.element),
    }
  }
}

#[derive(Debug)]
pub struct List<T: Debug> {
  pub head: Option<Node<T>>,
}

impl<T: Debug> List<T> {
  pub fn new() -> Self {
    List { head: None }
  }

  pub fn new_from(vec: Vec<T>) -> Self {
    let mut list: List<T> = List::new();
    for element in vec {
      list.insert_at_end(element);
    }
    list
  }

  pub fn insert_at_beginning(&mut self, element: T) {
    let mut new_node = Node {
      next: None,
      element,
    };
    match self.head {
      None => self.head = Some(new_node),
      Some(_) => {
        let current_head = self.head.take().unwrap();
        new_node.next = Some(Box::new(current_head));
        self.head = Some(new_node);
      }
    }
  }

  pub fn delete_at_beginning(&mut self) {
    self
      .head
      .take()
      .map(|head| self.head = head.next.map(|node| *node));
  }

  pub fn length(&self) -> usize {
    let mut count = 0;
    let mut current_node = self.head.as_ref();
    while let Some(node) = current_node {
      count = count + 1;
      current_node = node.next.as_ref().map(|node| &**node)
    }
    count
  }

  pub fn add_all(&mut self, list_to_add: List<T>) {
    let length = self.length();
    if length > 0 {
      let last_node = self.get_nth_node_mut(length - 1);
      last_node.map(|node| {
        node.next = list_to_add.head.map(|node| Box::new(node))
      });
    } else {
      self.head = list_to_add.head
    }
  }

  pub fn add_all_at_index(&mut self, list_to_add: List<T>, index: usize) {
    if index > 0 {
      let nth_node = self.get_nth_node_mut(index).take();
      println!("{:?}", nth_node);
      nth_node.map(|node| {
        let current_next = node.next.take();
        node.next = list_to_add.head.map(|node| Box::new(node));
      });
    } else {
      self.head = list_to_add.head
    }
  }

  pub fn insert_at_end(&mut self, element: T) {
    let length = self.length();
    let new_node = Node {
      element: element,
      next: None,
    };
    if length > 0 {
      let last_node = self.get_nth_node_mut(length - 1);
      last_node.map(|node| node.next = Some(Box::new(new_node)));
    } else {
      self.head = Some(new_node)
    }
  }

  pub fn insert_at_index(&mut self, element: T, index: usize) {
    let new_node = Node {
      element: element,
      next: None,
    };
    if index > 0 {
      let last_node = self.get_nth_node_mut(index - 1);
      last_node.map(|node| node.next = Some(Box::new(new_node)));
    }
  }


  pub fn delete_at_end(&mut self) {
    let length = self.length();
    if length > 0 {
      let mut last_node = self.get_nth_node_mut(length - 1);
      last_node.take();
    }
  }

  fn get_nth_node_mut(&mut self, n: usize) -> Option<&mut Node<T>> {
    let mut nth_node = self.head.as_mut();
    for _ in 0..n {
      nth_node = match nth_node {
        None => return None,
        Some(node) => node.next.as_mut().map(|node| &mut **node),
      }
    }
    nth_node
  }

  pub fn iter(&self) -> ListIterator<T> {
    ListIterator {
      next: self.head.as_ref(),
    }
  }

  pub fn into_iter(self) -> ListOwnedIterator<T> {
    ListOwnedIterator { next: self.head }
  }

  pub fn iter_mut(&mut self) -> ListMutIterator<T> {
    ListMutIterator {
      next: self.head.as_mut(),
    }
  }

  //  fn iter_mut_node(&mut self) -> ListMutNodeIterator<T> {
  //   ListMutNodeIterator {
  //     next_node: None
  //     // next_node: self.head.as_mut().map(|node| &mut node)
  //   }
  // }
}

pub struct ListIterator<'a, T: Debug + 'a> {
  next: Option<&'a Node<T>>,
}

impl<'a, T: Debug> Iterator for ListIterator<'a, T> {
  type Item = &'a T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.map(|node| {
      self.next = node.next.as_ref().map(|node| &**node);
      &node.element
    })
  }
}

pub struct ListOwnedIterator<T: Debug> {
  next: Option<Node<T>>,
}

impl<T: Debug> Iterator for ListOwnedIterator<T> {
  type Item = T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.take().map(|mut node| {
      self.next = node.next.take().map(|node| *node);
      node.element
    })
  }
}

pub struct ListMutIterator<'a, T: Debug + 'a> {
  next: Option<&'a mut Node<T>>,
}

impl<'a, T: Debug> Iterator for ListMutIterator<'a, T> {
  type Item = &'a mut T;
  fn next(&mut self) -> Option<Self::Item> {
    self.next.take().map(|node| {
      self.next = node.next.as_mut().map(|next_node| &mut **next_node);
      &mut node.element
    })
  }
}

// struct ListMutNodeIterator<'a, T: Debug + 'a> {
//   next_node: Option< &'a mut Node<T>>,
// }

// impl<'a, T: Debug> Iterator for ListMutNodeIterator<'a, T> {
//   type Item =  &'a mut Node<T>;
//   fn next(&mut self) -> Option<Self::Item> {
//     self.next_node.take().map(|node| {
//       let next = node.next.take();
//       self.next_node = next.as_mut().map(|next_node| &mut **next_node);
//       node
//     });
//     None
//   }
// }

impl<T: Debug> Display for List<T> {
  fn fmt(&self, f: &mut Formatter) -> Result {
    let _ = write!(f, "[");
    match self.head {
      None => {}
      Some(ref node) => {
        let _ = write!(f, "{}", node);
      }
    }
    write!(f, "]")
  }
}
