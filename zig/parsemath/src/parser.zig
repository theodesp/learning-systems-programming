pub const ParseError = error {
    UnableToParse,
    InvalidOperator,
};


pub fn evaluate(input: []u8) !?f64 {
    _ = input;
    return ParseError.UnableToParse;
}
