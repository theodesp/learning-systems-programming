use std::iter::Peekable;
use std::str::Chars;

//Other internal modules
use super::token::Token;

/// The tokenizer is the module in our system design that reads one or more characters
/// from an arithmetic expression and translates it into a token.
/// In other words, input is a set of characters and output is a set of tokens.
/// We need a lifetime annotation of 'a so that any reference to the Tokenizer struct cannot outlive the reference to the characters it contains.
///
/// When we instantiate the Tokenizer struct, we pass the string reference to it, which contains the arithmetic expression.
/// The expr variable needs to be valid for the duration that the Tokenizer object is in existence, otherwise we will have dangling pointers.
pub struct Tokenizer<'a> {
    // This will allow us to take a peek at the character following the next character in the input expression
    expr: Peekable<Chars<'a>>,
}

/// Tokenizer Implementation. Lifetime variables are declared with <'a>
impl<'a> Tokenizer<'a> {
    // Creates a new tokenizer using the arithmetic expression provided by the user
    pub fn new(new_expr: &'a str) -> Self {
        Tokenizer {
            expr: new_expr.chars().peekable(),
        }
    }
}
/// implement the Iterator trait on the Tokenizer struct. See: https://doc.rust-lang.org/beta/rust-by-example/trait/iter.html#iterators
impl<'a> Iterator for Tokenizer<'a> {
    type Item = Token;

    fn next(&mut self) -> Option<Token> {
        let next_char = self.expr.next();
        match next_char {
            // Matches digit
            Some('0'..='9') => {
                // Construct string by peeking next chars until we reach a non-digit character unless is a dot char (.)
                let mut number = next_char?.to_string();
                while let Some(next_char) = self.expr.peek() {
                    if next_char.is_numeric() || next_char == &'.' {
                        number.push(self.expr.next()?);
                    } else if next_char == &'(' {
                        return None;
                    } else {
                        break;
                    }
                }
                // Str -> f64. May panic
                Some(Token::Num(number.parse::<f64>().unwrap()))
            }
            Some('+') => Some(Token::Add),
            Some('-') => Some(Token::Subtract),
            Some('*') => Some(Token::Multiply),
            Some('/') => Some(Token::Divide),
            Some('^') => Some(Token::Caret),
            Some('(') => Some(Token::LeftParen),
            Some(')') => Some(Token::RightParen),
            None => Some(Token::EOF),
            Some(_) => None,
        }
    }
}
