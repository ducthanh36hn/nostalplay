/// Logical inputs of the 4-button handheld: D-pad directions plus A and B.
enum GameAction { up, down, left, right, buttonA, buttonB }

typedef GameActionCallback = void Function(GameAction action);
